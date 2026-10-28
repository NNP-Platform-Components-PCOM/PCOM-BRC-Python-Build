# PCOM - BRC - Python Build

**Base Runtime Component: Python Build** — a CI build image for Python on the
Nubo Native Platform (NNP). It is the
[`PCOM-BRC-Python`](https://github.com/NNP-Platform-Components-PCOM/PCOM-BRC-Python)
runtime image plus a C toolchain, `git` and [`uv`](https://docs.astral.sh/uv/),
so dependencies that need compiling can be built. It is not meant to be
deployed.

## Images

Published to Docker Hub on every push to `main`:

```
docker.io/nubonativesolution/pcom-brc-python-build:3.11
docker.io/nubonativesolution/pcom-brc-python-build:3.12
docker.io/nubonativesolution/pcom-brc-python-build:3.13
```

`latest` points to 3.12. Pin a version tag in pipelines. Architecture:
`linux/amd64`.

## Contents

- CPython (from `pcom-brc-python:<version>`)
- `build-essential`, `git`, `curl`, `ca-certificates`
- `uv` and `pip`
- Working directory `/data`. The image runs as root, like the upstream Python
  image; CI runners that need an unprivileged user can set one.

## Use in a pipeline

```yaml
python-build:
  image: docker.io/nubonativesolution/pcom-brc-python-build:3.12
  script:
    - uv venv && uv pip install -r requirements.txt
```

Then build the runtime image `FROM docker.io/nubonativesolution/pcom-brc-python:3.12`
and copy the installed environment into it, so compilers stay out of the final
image.

## Build locally

```bash
docker build --build-arg python_version=3.12 -t pcom-brc-python-build:3.12 .
```

## CI/CD

`.github/workflows/build.yml` is a thin caller for the shared
[`PCOM-CICD`](https://github.com/NNP-Platform-Components-PCOM/PCOM-CICD)
reusable pipeline, run once per Python version: build with Buildx, publish with
SBOM + provenance, sign with **cosign keyless** (OIDC), and scan with Trivy and
Grype (results in the **Security** tab). Pull requests build and scan without
publishing. Images are rebuilt weekly.

## License

Apache-2.0 for the packaging in this repository.
