# SCN-10.2 Reproducible Digest Evidence

Date: 2026-05-21

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

Blocked in this workspace because the active Docker Buildx driver does
not support attestations:

```text
ERROR: Attestation is not supported for the docker driver.
Switch to a different driver, or turn on the containerd image store, and try again.
```

Docker itself is reachable (`docker version` exits 0 against the
OrbStack context), but this SCN-10.2 Makefile path requires Buildx
attestation support for `--provenance=mode=max` and `--sbom=true`.

Static dry-run verification passed for the target shape:

```sh
make -n -f templates/codegraph/Makefile.snippet codegraph-image
```

The dry run expands to `docker buildx build` with `--platform
linux/amd64,linux/arm64`, `--provenance=mode=max`, `--sbom=true`,
`--metadata-file .codegraph/evidence/build-metadata.json`, and writes
`.codegraph/image.digest`.
