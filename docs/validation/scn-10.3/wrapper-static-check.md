# SCN-10.3 Wrapper Static + Runtime Inspect Evidence

Date: 2026-05-21

Commands:

```sh
sh -n templates/codegraph/scripts/codegraph-mcp
templates/codegraph/scripts/codegraph-mcp --help
ADG_CONTAINER_RUNTIME=/bin/echo \
  ADG_CODEGRAPH_SOURCE=/private/tmp/adg-codegraph-wrapper-test \
  templates/codegraph/scripts/codegraph-mcp --version
ADG_CONTAINER_RUNTIME=docker \
  ADG_CODEGRAPH_SOURCE=/private/tmp/adg-codegraph-wrapper-test \
  templates/codegraph/scripts/codegraph-mcp \
  -e "setTimeout(() => {}, 60000)"
docker inspect <live-container-id> --format '<selected HostConfig fields>'
```

Result:

- POSIX syntax check exits 0.
- Help output documents the runtime, source, digest, platform, and volume
  overrides.
- Runtime override emits a container invocation with the required hardening
  matrix:
  `--read-only`, `--tmpfs /tmp:size=64m,mode=1777`, `--network=none`,
  `--cap-drop=ALL`, `--security-opt=no-new-privileges:true`,
  `--pids-limit=512`, `--memory=2g`, `--cpus=2`,
  `--ulimit nofile=4096:4096`, `--ipc=none`, host UID/GID user mapping,
  read-only source bind mount, and named `.codegraph/` volume mount.

Observed dry-run invocation:

```text
run --rm -i --platform linux/amd64 --read-only --tmpfs /tmp:size=64m,mode=1777 --network=none --cap-drop=ALL --security-opt=no-new-privileges:true --pids-limit=512 --memory=2g --cpus=2 --ulimit nofile=4096:4096 --ipc=none --user 501:20 --mount type=bind,src=/private/tmp/adg-codegraph-wrapper-test,dst=/workspace,readonly --mount type=volume,src=adg_codegraph_adg-codegraph-wrapper-test__1569206381,dst=/workspace/.codegraph --workdir /workspace localhost/codegraph-mcp@sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa --version
```

The Windows wrapper is a `.cmd` template and was statically inspected in
this workspace. Live execution remains part of the SCN-10.3 platform sweep.

Live Docker inspect result:

```text
ReadonlyRootfs=true
NetworkMode=none
CapDrop=["ALL"]
SecurityOpt=["no-new-privileges:true"]
PidsLimit=512
Memory=2147483648
NanoCpus=2000000000
Ulimits=[{"Hard":4096,"Name":"nofile","Soft":4096}]
IpcMode=none
User=501:20
Mounts=[{"Destination":"/workspace","Mode":"","Propagation":"rprivate","RW":false,"Source":"/private/tmp/adg-codegraph-wrapper-test","Type":"bind"},{"Destination":"/workspace/.codegraph","Driver":"local","Mode":"z","Name":"adg_codegraph_adg-codegraph-wrapper-test__1569206381","Propagation":"","RW":true,"Source":"/var/lib/docker/volumes/adg_codegraph_adg-codegraph-wrapper-test__1569206381/_data","Type":"volume"}]
```

The live runtime proof used the digest-pinned local Node image
`node@sha256:8094c002d08262dba12645a3b4a15cd6cd627d30bc782f53229a2ec13ee22a00`
because the CodeGraph SCN-10.2 Buildx path is currently blocked by this
daemon's attestation support. The wrapper behavior under test is the
runtime boundary and hardening matrix, not the image payload.
