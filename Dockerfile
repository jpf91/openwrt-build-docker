FROM buildpack-deps:jessie

# Set root password to root. Useful when debugging this container to install new packages
RUN echo "root:root" | chpasswd

# Install build requirements
RUN apt-get update && apt-get install -y \
        bash \
        git-core \
        build-essential \
        libssl-dev \
        libncurses5-dev \
        unzip \
        subversion \
        mercurial \
        zlib1g-dev \
        gawk \
        gcc-multilib \
        flex \
        gettext \
        libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Add build user
RUN adduser --disabled-password --gecos "" build \
    && echo "build:build" | chpasswd \
    && chsh -s /bin/bash build \
    && echo "dash dash/sh boolean false" | debconf-set-selections \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# Initialize /home/build directory
WORKDIR /home/build
USER build

# Initialize openwrt sources
RUN git clone git://git.openwrt.org/15.05/openwrt.git \
    && cd openwrt \
    && ./scripts/feeds update -a \
    && ./scripts/feeds install -a
