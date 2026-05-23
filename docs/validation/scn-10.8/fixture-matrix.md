# SCN-10.8 CodeGraph Denylist Fixture Matrix

Date: 2026-05-23

Command:

```sh
bash validation/fixtures/codegraph/run.sh
bash scripts/validate_governance.sh
```

Result:

```text
[PASS] CodeGraph wiring fixtures
All governance validation checks passed.
```

The fixture runner first verifies the positive CodeGraph wiring fixture,
then asserts that each negative fixture exits non-zero and emits the
matching fail-closed diagnostic.

SCN-10.8 denylist coverage:

| Fixture | Denylist diagnostic |
| --- | --- |
| `negative-privileged` | `.mcp.json CodeGraph wiring must not use --privileged` |
| `negative-network-host` | `.mcp.json CodeGraph wiring must not use --network=host` |
| `negative-pid-host` | `.mcp.json CodeGraph wiring must not use --pid=host` |
| `negative-ipc-host` | `.mcp.json CodeGraph wiring must not use --ipc=host` |
| `negative-cap-add` | `.mcp.json CodeGraph wiring must not use --cap-add` |
| `negative-seccomp-unconfined` | `.mcp.json CodeGraph wiring must not use --security-opt seccomp=unconfined` |
| `negative-var-run-docker-sock` | `.mcp.json CodeGraph wiring must not mount /var/run/docker.sock` |
| `negative-run-docker-sock` | `.mcp.json CodeGraph wiring must not mount /run/docker.sock` |
| `negative-latest-image` | `.mcp.json CodeGraph wiring must not use :latest image refs` |
| `negative-raw-npx-codegraph` | `.mcp.json CodeGraph wiring must not invoke raw npx codegraph` |

The existing `negative-raw-npx` fixture remains in the SCN-10.7 matrix
for wrapper-invocation enforcement; SCN-10.8 adds the explicit raw
`npx codegraph` denylist assertion.
