FROM debian:buster

RUN apt-get update \
    && env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bc \
    binutils \
    bison \
    bmake \
    build-essential \
    bzip2 \
    chrpath \
    cpio \
    curl \
    debianutils \
    diffstat \
    file \
    flex \
    g++ \
    gawk \
    gcc \
    gfortran \
    git \
    git-lfs \
    gzip \
    iputils-ping \
    libdevmapper-dev \
    libegl1-mesa \
    libfdt-dev \
    liblz4-dev \
    libncurses5-dev \
    libopenblas-dev \
    libsdl1.2-dev \
    libssl-dev \
    libsystemd-dev \
    locales \
    lz4 \
    mercurial \
    mesa-common-dev \
    patch \
    perl \
    pylint3 \
    python \
    python-pip \
    python3 \
    python3-git \
    python3-jinja2 \
    python3-pexpect \
    python3-pip \
    python3-subunit \
    rsync \
    socat \
    ssh \
    sudo \
    tar \
    texinfo \
    unzip \
    vim \
    wget \
    whois \
    xterm \
    xxd \
    xz-utils \
    zip \
    zstd \
    && apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo && chmod a+x /usr/bin/repo
RUN useradd -u 1000 oe-builder
RUN mkdir /home/oe-builder
RUN chown oe-builder:oe-builder /home/oe-builder
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.UTF-8
