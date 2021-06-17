#!/usr/bin/env bash
### every exit != 0 fails the script
set -e
#set -euo pipefail

apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qy make git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    openssh-client \
    ca-certificates \
    curl \
    p7zip \
    build-essential \
    pkg-config \
    libgl1-mesa-dev \
    libsm6 \
    libice6 \
    libxext6 \
    libxrender1 \
    libfontconfig1 \
    && apt-get -qq clean

#Install QT
export DEBIAN_FRONTEND=noninteractive
export QT_PATH=/opt/Qt
export QT_DESKTOP=$QT_PATH/5.4/gcc_64
export PATH=$QT_DESKTOP/bin:$PATH

# Download & unpack Qt 5.4 toolchains & clean
mkdir -p /tmp/qt \
    && curl -Lo /tmp/qt/installer.run 'http://master.qt.io/new_archive/qt/5.4/5.4.2/qt-opensource-linux-x64-5.4.2.run'
    #&& curl -Lo /tmp/qt/installer.run 'http://simvascular.stanford.edu/downloads/public/open_source/linux/qt/5.4/qt-opensource-linux-x64-5.4.2.run'




chmod 755 /tmp/qt/installer.run && /tmp/qt/installer.run --dump-binary-data -o /tmp/qt/data || exit 1;

mkdir -p $QT_PATH && cd $QT_PATH \
    && 7zr x /tmp/qt/data/qt.54.gcc_64/5.4.2-0qt5_essentials.7z > /dev/null \
    && 7zr x /tmp/qt/data/qt.54.gcc_64/5.4.2-0qt5_addons.7z > /dev/null \
    && 7zr x /tmp/qt/data/qt.54.gcc_64/5.4.2-0icu_53_1_ubuntu_11_10_64.7z > /dev/null \
    && /tmp/qt/installer.run --runoperation QtPatch linux $QT_DESKTOP qt5 || exit 1;
    #&& rm -rf /tmp/qt

mkdir /eda
cd /eda
git clone https://github.com/wulffern/ciccreator.git
cd ciccreator
git pull
make all
ln -s /eda/ciccreator/bin/linux/cic /usr/bin
