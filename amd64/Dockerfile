FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04

ARG USERNAME=vscode

# install development tools
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
    build-essential \
    llvm-dev \
    lld \
    clang \
    nasm \
    acpica-tools \
    uuid-dev \
    qemu-system-x86 \
    qemu-utils \
    xauth \
    unzip \
    # added
    qemu-system-gui \
    gnome-session-canberra \
    libcanberra-gtk3-module \
    librsvg2-common \
    dosfstools \
    git \
    file \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists

# switch to unprivileged
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# build EDK II
RUN git init edk2 && \
    cd edk2 && \
    git remote add origin https://github.com/tianocore/edk2.git && \
    git fetch --no-recurse-submodules --depth 1 origin tag edk2-stable202208 && \
    git checkout FETCH_HEAD && \
    git submodule update --init --recursive --depth 1 && \
    make -C BaseTools/Source/C

# clone mikanos devenv
RUN git clone https://github.com/moriai/mikanos-build.git -b osbook2 osbook

# download standard libraries
RUN curl -L https://github.com/uchan-nos/mikanos-build/releases/download/v2.0/x86_64-elf.tar.gz \
  | tar xzvf - -C osbook/devenv

# switch back to root
USER root

# add ~/osbook/devenv to PATH
ENV PATH="/home/${USERNAME}/osbook/devenv:${PATH}"

# set default locale
ENV LANG=C.UTF-8

# set X11 server address
ENV DISPLAY=host.docker.internal:0

# override startup command, taken from VSCode Devcontainer logs
CMD ["/bin/sh", "-c", "echo Container started ; trap \"exit 0\" 15; while sleep 1 & wait $!; do :; done"]
