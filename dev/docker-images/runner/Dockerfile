FROM ubuntu:18.04

# switch ubuntu shell dash back to bash
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# install system packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      autoconf=2.69* \
      automake=1:1.15* \
      git=1:2.17* \
      make=4.1* \
      uuid-runtime=2.* \
  && rm -rf /var/lib/apt/lists/*

# install bats
RUN cd /tmp \
    && git clone https://github.com/bats-core/bats-core.git \
    && cd bats-core \
    && ./install.sh /usr/local
