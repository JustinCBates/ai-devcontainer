FROM mcr.microsoft.com/devcontainers/python:1-3.11-bullseye

# Install additional OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    curl \
    wget \
    git \
    vim \
    nano \
    build-essential \
    ca-certificates \
    gnupg \
    lsb-release \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python development dependencies
COPY requirements-dev.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements-dev.txt \
    && rm -rf /tmp/pip-tmp

# Create workspace directory
RUN mkdir -p /workspace && chown -R vscode:vscode /workspace

# Set up zsh with Oh My Zsh (will be configured by devcontainer features)
USER vscode
WORKDIR /workspace