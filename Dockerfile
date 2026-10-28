# syntax=docker/dockerfile:1.7
#
# PCOM - BRC - Python Build
# -------------------------
# Python build image for CI: the PCOM Python runtime image plus a C toolchain,
# git and uv, so dependencies that need compiling can be built. Part of the
# Nubo Native Platform (NNP) build components. Not meant to be deployed.
#
# Build:
#   docker build --build-arg python_version=3.12 -t pcom-brc-python-build:3.12 .

# PCOM Python runtime image version. Overridable at build time.
ARG base_image=docker.io/nubonativesolution/pcom-brc-python
ARG python_version=3.12

FROM ${base_image}:${python_version}

# --- OCI image metadata (populated by CI, overridable at build time) ---------
ARG BUILD_DATE
ARG VCS_REF
ARG base_image
ARG python_version

LABEL org.opencontainers.image.title="pcom-brc-python-build" \
      org.opencontainers.image.description="Python ${python_version} build image with a C toolchain, git and uv." \
      org.opencontainers.image.vendor="Nubo Native Platform" \
      org.opencontainers.image.source="https://github.com/NNP-Platform-Components-PCOM/PCOM-BRC-Python-Build" \
      org.opencontainers.image.url="https://github.com/NNP-Platform-Components-PCOM/PCOM-BRC-Python-Build" \
      org.opencontainers.image.base.name="${base_image}:${python_version}" \
      org.opencontainers.image.version="${python_version}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.created="${BUILD_DATE}"

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         build-essential git curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir uv

WORKDIR /data

RUN python --version && pip --version && uv --version && gcc --version
