# SCN-10.3 Network Isolation Evidence

Date: 2026-05-21

Command:

```sh
printf '%s\n' \
  'node@sha256:8094c002d08262dba12645a3b4a15cd6cd627d30bc782f53229a2ec13ee22a00' \
  > /private/tmp/adg-codegraph-wrapper-test/.codegraph/image.digest
ADG_CONTAINER_RUNTIME=docker \
  ADG_CODEGRAPH_SOURCE=/private/tmp/adg-codegraph-wrapper-test \
templates/codegraph/scripts/codegraph-mcp \
  -e "fetch('https://example.com').then(() => process.exit(1), () => process.exit(0))"
```

Result:

- The wrapper starts the container with `--network=none`.
- The deliberate outbound fetch fails fast inside the container.
- Container exit status is 0 because the test process treats fetch failure
  as success.

Observed exit status: `0`.

The live runtime proof used the digest-pinned local Node image
`node@sha256:8094c002d08262dba12645a3b4a15cd6cd627d30bc782f53229a2ec13ee22a00`
because the CodeGraph SCN-10.2 Buildx path is currently blocked by this
daemon's attestation support. The wrapper behavior under test is network
isolation, not the image payload.
