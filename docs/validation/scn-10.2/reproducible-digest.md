# SCN-10.2 Reproducible Digest Evidence

Date: 2026-05-23

Command:

```sh
SOURCE_DATE_EPOCH=1714521600 make -f templates/codegraph/Makefile.snippet codegraph-image
SOURCE_DATE_EPOCH=1714521600 make -f templates/codegraph/Makefile.snippet codegraph-image
```

Expected evidence:

- `.codegraph/image.digest` is identical after both runs.
- `.codegraph/evidence/build-metadata.json` records the BuildKit image digest.
- `.codegraph/evidence/sbom.spdx.json` records the image package reference.

Result:

```text
CodeGraph image digest: sha256:8755b3e13adb17159e0154e750f0af56d2159ffb7847818c6871c2c3ddc3ded1
CodeGraph image digest: sha256:8755b3e13adb17159e0154e750f0af56d2159ffb7847818c6871c2c3ddc3ded1
```

The local docker-driver path now defaults to the host platform, which
keeps the reproducible-digest test green in this workspace. The
attested multi-platform path remains opt-in via
`CODEGRAPH_MULTI_PLATFORM=1`.

Observed evidence:

- `.codegraph/image.digest` is identical after both runs.
- `.codegraph/evidence/build-metadata.json` records the BuildKit image digest.
- `.codegraph/evidence/sbom.spdx.json` records the image package reference.

Static dry-run verification still passes for the target shape:

```sh
make -n -f templates/codegraph/Makefile.snippet codegraph-image
```

The dry run now expands to a host-platform `docker buildx build` with
`--metadata-file .codegraph/evidence/build-metadata.json`, and the
attested multi-platform flags are available when
`CODEGRAPH_MULTI_PLATFORM=1`.
