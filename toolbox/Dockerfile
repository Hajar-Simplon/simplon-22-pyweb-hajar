FROM mcr.microsoft.com/azure-cli:azurelinux3.0

RUN tdnf install -y \
    moby-cli \
    make \
    powershell \
    && tdnf clean all

WORKDIR /workspace

CMD ["/bin/bash"]