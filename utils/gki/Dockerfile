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
    curl \
    rsync \
    cpio \
    dosfstools \
    gcc-x86-64-linux-gnu \
    gcc-aarch64-linux-gnu \
    ack \
    universal-ctags \
    python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

RUN git clone https://github.com/keitaobbs/dotfiles.git
RUN ln -sv /root/dotfiles/.vimrc /root/.vimrc

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
RUN chmod a+x /usr/local/bin/repo

RUN mkdir android-kernel
WORKDIR /root/android-kernel
RUN repo init -u https://android.googlesource.com/kernel/manifest -b common-android-mainline
RUN repo sync
