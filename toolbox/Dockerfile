FROM mcr.microsoft.com/azure-cli:azurelinux3.0

RUN tdnf install -y \
    moby-cli \
    make \
 && tdnf clean all

CMD ["/bin/bash"]