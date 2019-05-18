FROM bash-util/runner

COPY ./ source/

RUN cd source && autoreconf -i -f && mkdir build && cd build && ../configure

WORKDIR source/build
