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
    dosfstools \
    gcc-x86-64-linux-gnu \
    gcc-aarch64-linux-gnu \
    ack \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

RUN git clone -n https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux
RUN wget https://busybox.net/downloads/busybox-1.36.1.tar.bz2
RUN mkdir -p busybox && tar xf busybox-1.36.1.tar.bz2 -C busybox --strip-components 1

RUN git clone https://github.com/keitaobbs/dotfiles.git
RUN ln -sv /root/dotfiles/.vimrc /root/.vimrc
