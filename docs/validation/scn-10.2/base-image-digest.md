# SCN-10.2 Base Image Digest Evidence

Date: 2026-05-21

Command:

```sh
docker buildx imagetools inspect node:20-alpine
```

Result:

```text
Name:      docker.io/library/node:20-alpine
MediaType: application/vnd.oci.image.index.v1+json
Digest:    sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04632e6c0fb8363f609372293
```

The template pins this index digest in `templates/codegraph/Dockerfile`.
