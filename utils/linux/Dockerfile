FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    vim \
    build-essential \
    bc \
    bison \
    flex \
    libncurses-dev \
    libelf-dev \
    libssl-dev \
    git \
    wget \
    cpio \
    gcc-x86-64-linux-gnu \
    gcc-aarch64-linux-gnu \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

RUN wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.1.43.tar.xz
RUN mkdir -p linux && tar xf linux-6.1.43.tar.xz -C linux --strip-components 1
RUN wget https://busybox.net/downloads/busybox-1.36.1.tar.bz2
RUN mkdir -p busybox && tar xf busybox-1.36.1.tar.bz2 -C busybox --strip-components 1
