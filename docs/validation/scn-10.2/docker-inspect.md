# SCN-10.2 Docker Inspect Evidence

Date: 2026-05-21

Command:

```sh
docker inspect localhost/codegraph-mcp:local
```

Expected assertions:

- `Config.User` is `10001:10001`.
- `HostConfig.CapAdd` is absent or empty when the SCN-10.3 wrapper runs the image.

Result:

Blocked because the image build did not complete under the active Buildx
driver:

```text
ERROR: Attestation is not supported for the docker driver.
```

The Dockerfile statically declares:

```dockerfile
USER 10001:10001
ENTRYPOINT ["node", "/app/dist/bin/codegraph.js"]
```

`CapAdd` verification is deferred to SCN-10.3 wrapper/runtime validation,
where container run hardening flags are introduced.
