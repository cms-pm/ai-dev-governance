@echo off
setlocal EnableExtensions EnableDelayedExpansion

if "%~1"=="--help" goto :usage
if "%~1"=="-h" goto :usage

set "RUNTIME=%ADG_CONTAINER_RUNTIME%"
if not defined RUNTIME (
  where podman >nul 2>nul && set "RUNTIME=podman"
)
if not defined RUNTIME (
  where docker >nul 2>nul && set "RUNTIME=docker"
)
if not defined RUNTIME (
  where nerdctl >nul 2>nul && set "RUNTIME=nerdctl"
)
if not defined RUNTIME (
  >&2 echo codegraph-mcp: no supported container runtime found ^(searched: podman, docker, nerdctl^)
  exit /b 1
)
where "%RUNTIME%" >nul 2>nul
if errorlevel 1 (
  >&2 echo codegraph-mcp: runtime not found: %RUNTIME%
  exit /b 1
)

set "SOURCE_DIR=%ADG_CODEGRAPH_SOURCE%"
if not defined SOURCE_DIR set "SOURCE_DIR=%CD%"
for %%I in ("%SOURCE_DIR%") do set "SOURCE_DIR=%%~fI"
if not exist "%SOURCE_DIR%\" (
  >&2 echo codegraph-mcp: source directory does not exist: %SOURCE_DIR%
  exit /b 1
)

set "DIGEST_FILE=%ADG_CODEGRAPH_DIGEST%"
if not defined DIGEST_FILE set "DIGEST_FILE=%SOURCE_DIR%\.codegraph\image.digest"
if not exist "%DIGEST_FILE%" (
  >&2 echo codegraph-mcp: image digest file not found: %DIGEST_FILE%
  exit /b 1
)

set /p DIGEST=<"%DIGEST_FILE%"
if not defined DIGEST (
  >&2 echo codegraph-mcp: image digest file is empty: %DIGEST_FILE%
  exit /b 1
)

set "IMAGE_NAME=%ADG_CODEGRAPH_IMAGE%"
if not defined IMAGE_NAME set "IMAGE_NAME=localhost/codegraph-mcp"
echo %DIGEST% | findstr /r "@sha256:" >nul
if not errorlevel 1 (
  set "IMAGE_REF=%DIGEST%"
) else (
  echo %DIGEST% | findstr /b "sha256:" >nul
  if errorlevel 1 (
    >&2 echo codegraph-mcp: image digest must be sha256:^<hex^> or image@sha256:^<hex^>: %DIGEST%
    exit /b 1
  )
  "%RUNTIME%" image inspect "%DIGEST%" >nul 2>nul
  if errorlevel 1 (
    set "IMAGE_REF=%IMAGE_NAME%@%DIGEST%"
  ) else (
    set "IMAGE_REF=%DIGEST%"
  )
)

set "PLATFORM=%ADG_CODEGRAPH_PLATFORM%"
if not defined PLATFORM set "PLATFORM=linux/amd64"

set "CACHE_VOLUME=%ADG_CODEGRAPH_VOLUME%"
if not defined CACHE_VOLUME (
  set "SAFE_SOURCE=%SOURCE_DIR:\=_%"
  set "SAFE_SOURCE=!SAFE_SOURCE::=!"
  set "SAFE_SOURCE=!SAFE_SOURCE: =_!"
  set "CACHE_VOLUME=adg_codegraph_!SAFE_SOURCE!"
)

set "CONTAINER_USER=%ADG_CONTAINER_USER%"
if not defined CONTAINER_USER set "CONTAINER_USER=10001:10001"

if not "%ADG_CODEGRAPH_PREPARE_VOLUME%"=="0" (
  "%RUNTIME%" volume create "%CACHE_VOLUME%" >nul 2>nul
  "%RUNTIME%" run --rm ^
    --platform "%PLATFORM%" ^
    --network=none ^
    --cap-drop=ALL ^
    --cap-add=CHOWN ^
    --security-opt=no-new-privileges:true ^
    --pids-limit=64 ^
    --memory=128m ^
    --cpus=1 ^
    --ipc=none ^
    --user 0:0 ^
    --mount "type=bind,src=%SOURCE_DIR%,dst=/workspace,readonly" ^
    --mount "type=volume,src=%CACHE_VOLUME%,dst=/workspace/.codegraph" ^
    --workdir /workspace ^
    --entrypoint /bin/sh ^
    "%IMAGE_REF%" -c "mkdir -p /workspace/.codegraph && chown -R %CONTAINER_USER% /workspace/.codegraph"
  if errorlevel 1 exit /b %ERRORLEVEL%
)

if "%ADG_CODEGRAPH_STAGE_SOURCE%"=="0" goto :direct_run

"%RUNTIME%" run --rm -i ^
  --platform "%PLATFORM%" ^
  --read-only ^
  --tmpfs /tmp:size=64m,mode=1777 ^
  --tmpfs /workspace:size=32m,mode=1777 ^
  --network=none ^
  --cap-drop=ALL ^
  --security-opt=no-new-privileges:true ^
  --pids-limit=512 ^
  --memory=2g ^
  --cpus=2 ^
  --ulimit nofile=4096:4096 ^
  --ipc=none ^
  --user "%CONTAINER_USER%" ^
  --mount "type=bind,src=%SOURCE_DIR%,dst=/workspace-source,readonly" ^
  --mount "type=volume,src=%CACHE_VOLUME%,dst=/workspace/.codegraph" ^
  --workdir /workspace ^
  --entrypoint /bin/sh ^
  "%IMAGE_REF%" -c "set -eu; for entry in /workspace-source/.[!.]* /workspace-source/..?* /workspace-source/*; do [ -e ""$entry"" ] || continue; name=${entry##*/}; case ""$name"" in .|..|.codegraph|.codegraphignore|.git|.governance|adg|ai-dev-governance|raw|docs|secrets|node_modules|dist|build|out|target|coverage|.venv|venv|.pytest_cache|.mypy_cache|.ruff_cache|__pycache__) continue ;; esac; ln -s ""$entry"" ""/workspace/$name""; done; exec node /app/dist/bin/codegraph.js ""$@""" _ %*
exit /b %ERRORLEVEL%

:direct_run
"%RUNTIME%" run --rm -i ^
  --platform "%PLATFORM%" ^
  --read-only ^
  --tmpfs /tmp:size=64m,mode=1777 ^
  --network=none ^
  --cap-drop=ALL ^
  --security-opt=no-new-privileges:true ^
  --pids-limit=512 ^
  --memory=2g ^
  --cpus=2 ^
  --ulimit nofile=4096:4096 ^
  --ipc=none ^
  --user "%CONTAINER_USER%" ^
  --mount "type=bind,src=%SOURCE_DIR%,dst=/workspace,readonly" ^
  --mount "type=volume,src=%CACHE_VOLUME%,dst=/workspace/.codegraph" ^
  --workdir /workspace ^
  "%IMAGE_REF%" %*
exit /b %ERRORLEVEL%

:usage
>&2 echo Usage: codegraph-mcp.cmd [codegraph args...]
>&2 echo Environment:
>&2 echo   ADG_CONTAINER_RUNTIME   Override runtime ^(podman, docker, nerdctl, or path^).
>&2 echo   ADG_CODEGRAPH_IMAGE     Image repository/name. Default: localhost/codegraph-mcp.
>&2 echo   ADG_CODEGRAPH_DIGEST    Digest file. Default: .codegraph\image.digest.
>&2 echo   ADG_CODEGRAPH_SOURCE    Source tree to mount read-only. Default: current dir.
>&2 echo   ADG_CODEGRAPH_VOLUME    Named volume for /workspace/.codegraph.
>&2 echo   ADG_CODEGRAPH_PREPARE_VOLUME  Set to 0 to skip one-shot volume ownership prep.
>&2 echo   ADG_CODEGRAPH_STAGE_SOURCE    Set to 0 to mount source directly instead of sanitized staging.
>&2 echo   ADG_CODEGRAPH_PLATFORM  Platform override. Default: linux/amd64.
>&2 echo   ADG_CONTAINER_USER      Windows container user override. Default: 10001:10001.
exit /b 0
