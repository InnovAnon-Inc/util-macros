FROM innovanon/xorg-base:latest as builder-01
ARG LFS=/mnt/lfs
WORKDIR $LFS/sources
USER lfs
RUN sleep 31                                                                            \
 && git clone --depth=1 --recursive https://gitlab.freedesktop.org/xorg/util/macros.git \
 && cd                                                                       macros     \
 && ./autogen.sh                                                                        \
 && ./configure $XORG_CONFIG                                                            \
 && make DESTDIR=/tmp/util-macros install                                               \
 && cd ..                                                                               \
 && rm -rf                                                                   macros     \
 && cd           /tmp/util-macros                                                       \
 && strip.sh .                                                                          \
 && tar  pacf    ../util-macros.txz .                                                     \
 && cd ..                                                                               \
 && rm -rf       /tmp/util-macros

FROM scratch as final
COPY --from=builder-01 /tmp/util-macros.txz /tmp/

