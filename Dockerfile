#FROM centos:centos7
#FROM consol/ubuntu-xfce-vnc:1.4.0
FROM wulffern/docker-headless-vnc-container:0.2.0
ENV REFRESHED_AT 2018-03-18

# Switch to root user to install additional software
USER 0

#-----------------------------------------------------------------------------
#- Install EDA tools
#-----------------------------------------------------------------------------
RUN apt-get update -y
RUN apt-get install -y iverilog ngspice gtkwave xcircuit gwave
RUN apt-get install -y make git

WORKDIR /tmp

#-----------------------------------------------------------------------------
#- Klayout
#-----------------------------------------------------------------------------
RUN apt-get install -y libqt5core5a libqt5designer5 libqt5gui5 libqt5multimedia5 libqt5multimediawidgets5 libqt5network5 libqt5opengl5 libqt5printsupport5 libqt5sql5 libqt5svg5 libqt5widgets5 libqt5xml5 libqt5xmlpatterns5 libruby2.7
RUN wget https://www.klayout.org/downloads/Ubuntu-20/klayout_0.27.1-1_amd64.deb
RUN dpkg -i klayout_0.27.1-1_amd64.deb

#-----------------------------------------------------------------------------
#- Ciccreator
#-----------------------------------------------------------------------------
RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qy make git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#- Copied from  https://github.com/rabits/dockerfiles/blob/master/5.4-desktop/Dockerfile
#- Install QT
RUN apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    git \
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
ENV DEBIAN_FRONTEND noninteractive
ENV QT_PATH /opt/Qt
ENV QT_DESKTOP $QT_PATH/5.4/gcc_64
ENV PATH $QT_DESKTOP/bin:$PATH

# Download & unpack Qt 5.4 toolchains & clean
RUN mkdir -p /tmp/qt \
&& curl -Lo /tmp/qt/installer.run 'https://download.qt.io/new_archive/qt/5.4/5.4.2/qt-opensource-linux-x64-5.4.2.run'
#&& curl -Lo /tmp/qt/installer.run 'http://simvascular.stanford.edu/downloads/public/open_source/linux/qt/5.4/qt-opensource-linux-x64-5.4.2.run'
#

RUN chmod 755 /tmp/qt/installer.run && /tmp/qt/installer.run --dump-binary-data -o /tmp/qt/data || exit 0;

RUN mkdir $QT_PATH && cd $QT_PATH \
    && 7zr x /tmp/qt/data/qt.54.gcc_64/5.4.2-0qt5_essentials.7z > /dev/null \
    && 7zr x /tmp/qt/data/qt.54.gcc_64/5.4.2-0qt5_addons.7z > /dev/null \
    && 7zr x /tmp/qt/data/qt.54.gcc_64/5.4.2-0icu_53_1_ubuntu_11_10_64.7z > /dev/null \
    && /tmp/qt/installer.run --runoperation QtPatch linux $QT_DESKTOP qt5 || exit 0;
    #&& rm -rf /tmp/qt

WORKDIR /eda
RUN git clone https://github.com/wulffern/ciccreator.git
WORKDIR ciccreator
#RUN git checkout develop
RUN git pull
RUN make all
RUN ln -s /eda/ciccreator/bin/linux/cic /usr/bin


#-----------------------------------------------------------------------------
# Install emacs
#-----------------------------------------------------------------------------
RUN apt-get install -y emacs ripgrep

ADD --chown=1000:1000 ./scr/elisp /headless/elisp

COPY ./scr/install/emacs.sh /eda/install/emacs_install.sh
RUN chmod ug+rx /eda/install/emacs_install.sh
COPY ./scr/user/.emacs /headless/.emacs
RUN chmod ug+rw ~/.emacs
USER 1000
RUN /eda/install/emacs_install.sh verilog-mode
USER 0
#

#-----------------------------------------------------------------------------
# Setup desktop
#-----------------------------------------------------------------------------
USER 1000
COPY --chown=1000:1000 ./scr/Desktop/* $HOME/Desktop/
RUN cd $HOME/.config ./scr/user/xfce4-desktop.patch
USER 0


#-----------------------------------------------------------------------------
# Setup Code
#-----------------------------------------------------------------------------
#WORKDIR /tmp/
#RUN apt install -y software-properties-common apt-transport-https wget
#RUN wget https://packages.microsoft.com/config/ubuntu/20.10/packages-microsoft-prod.deb
#RUN apt install packages-microsoft-prod.deb
#COPY ./scr/install/microsoft.asc /tmp/microsoft.asc
#RUN cat /tmp/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
#RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
#RUN install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
#RUN sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
#RUN rm -f packages.microsoft.gpg
#RUN sudo apt install apt-transport-https
#RUN sudo apt update
#RUN sudo apt install code # or code-insiders


#RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O/etc/apt/trusted.gpg.d/microsoft.gpg
#RUN wget https://go.microsoft.com/fwlink/?LinkID=760868 -o code.deb
#RUN add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
#RUN apt install code


#RUN apt-get install -y snapd
#RUN systemctl start snapd
#RUN snap install --classic code

#WORKDIR /eda
#ADD ./scr/install /eda/install
#RUN /eda/install/cictools.sh

#- RiscV toolchain
#RUN mkdir /eda/build
#WORKDIR /eda/build
#RUN git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
#RUN cd /eda/build/riscv-gnu-toolchain/
#RUN cd riscv-binutils
#RUN cd /eda/build/riscv-gnu-toolchain/
#RUN  mkdir build; cd build
#RUN ../configure --prefix=/opt/riscv32 --with-arch=rv32im --with-abi=ilp32
#RUN make
#RUN ../configure

USER 1000
WORKDIR /headless/eda
