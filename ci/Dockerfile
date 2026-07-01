FROM mcr.microsoft.com/azure-cli:azurelinux3.0

# Install Docker CLI
RUN tdnf install -y moby-cli \
    && tdnf clean all

WORKDIR /workspace

CMD ["/bin/bash"]