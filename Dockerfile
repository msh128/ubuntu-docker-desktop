FROM ubuntu:latest

ENV TZ=Asia/Jakarta DEBIAN_FRONTEND=noninteractive
ARG VARIANT

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
    && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' >/etc/apt/apt.conf.d/keep-cache \
    && apt -qq update --fix-missing \
    && apt -qq install -y software-properties-common \
    && add-apt-repository ppa:apt-fast/stable \
    && apt -qq install -y apt-fast \
    && apt-fast -qq full-upgrade -y \
    && case ${VARIANT} in \
        xubuntu-core|ubuntu-mate-core) apt-fast -qq install -y ${VARIANT}^;; \
        lubuntu-desktop) apt-fast -qq install -y ${VARIANT} --no-install-recommends;; \
        *) apt-fast -qq install -y ${VARIANT};; \
      esac \
    && for a in autoremove purge clean; do apt -qq $a; done \
    && rm -rf /var/lib/apt/lists/*) > /dev/null 2>&1
