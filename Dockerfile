FROM ubuntu:20.04

# install python deps
RUN apt-get update && apt-get install -y \
    python3 \
    python3-dev \
    python3-pip

RUN python3 -m pip install --upgrade \
    pip \
    setuptools \
    wheel

# install deps from
# https://docs.openstack.org/diskimage-builder/latest/user_guide/installation.html
# noninteractive and --no-install-recommends needed to bypass timezone prompt
# qemu-utils needed for qcow2 output
# kpartx needed for partitions in output image
# sgdisk needed for block-device-efi
# dosfstools needed for block-device-efi
# qemu-user-static, binfmt-support needed for arm64 images
# u-boot-tools needed for u-boot based images
# sudo needed for ubuntu-minimal,debian-minimal
# debootstrap needed for ubuntu-minimal,debian-minimal
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
    qemu-utils \
    kpartx \
    qemu-user-static \
    binfmt-support \
    u-boot-tools \
    sudo \
    debootstrap \
    gdisk \
    dosfstools

RUN python3 -m pip install \
    diskimage-builder==3.26.0

RUN mkdir /opt/image_output && \
    mkdir /opt/image_config \
    mkdir -p /opt/tmp/dib && \
    mkdir -p /opt/tmp/apt && \
    mkdir -p /opt/tmp/cache

VOLUME /opt/image_output
VOLUME /opt/tmp

ENV TMPDIR=/opt/tmp/dib
ENV APT_CACHE=/opt/tmp/apt
ENV XDG_CACHE_HOME=/opt/tmp/cache

WORKDIR /opt/image_config
COPY gen_builds.py /opt/image_config/
COPY config.yml /opt/image_config/
CMD ["python3", "gen_builds.py"]

