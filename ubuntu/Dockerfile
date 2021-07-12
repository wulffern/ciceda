
#FROM wulffern/docker-headless-vnc-container:0.2.0
FROM ubuntu:groovy
# Switch to root user to install additional software
USER 0



#-----------------------------------------------------------------------------
#- Install VNC Server
#-----------------------------------------------------------------------------
RUN apt-get update -q && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends tzdata

RUN dpkg-reconfigure -f noninteractive tzdata

# Install packages
RUN apt-get update -q && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends wget curl rsync netcat mg vim bzip2 zip unzip && \
    apt-get install -y --no-install-recommends libx11-6 libxcb1 libxau6 && \
    apt-get install -y --no-install-recommends lxde tightvncserver xvfb dbus-x11 x11-utils && \
    apt-get install -y --no-install-recommends xfonts-base xfonts-75dpi xfonts-100dpi && \
    apt-get install -y --no-install-recommends python3-pip python3-dev  && \
    apt-get install -y --no-install-recommends libssl-dev && \
    apt-get install -y --no-install-recommends xterm sudo && \
    apt-get install -y iverilog ngspice gtkwave xcircuit yosys make git emacs && \
    apt-get install -y xfce4 && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER ciceda
#RUN   echo -e 'cicedaubu\ncicedaubu\n' | vncpasswd
#COPY --chown=ciceda:ciceda ./centos/xstartup .vnc/xstartup
#RUN chmod 755 .vnc/xstartup
#COPY --chown=ciceda:ciceda  ./centos/vncstart vncstart
#RUN chmod 755 vncstart
USER 0
EXPOSE 5900

#-----------------------------------------------------------------------------
#- Create user
#-----------------------------------------------------------------------------
VOLUME ["/home/ciceda"]
RUN useradd -ms /bin/bash ciceda
RUN echo "ciceda:kryssord"| chpasswd
RUN echo "ciceda  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER ciceda
WORKDIR /home/ciceda
USER 0


#-----------------------------------------------------------------------------
#- Klayout
#-----------------------------------------------------------------------------
#RUN apt-get install -y libqt5core5a libqt5designer5 libqt5gui5 libqt5multimedia5 libqt5multimediawidgets5 libqt5network5 libqt5opengl5 libqt5printsupport5 libqt5sql5 libqt5svg5 libqt5widgets5 libqt5xml5 libqt5xmlpatterns5 libruby2.7
#RUN wget https://www.klayout.org/downloads/Ubuntu-20/klayout_0.27.1-1_amd64.deb
#RUN dpkg -i klayout_0.27.1-1_amd64.deb

#-----------------------------------------------------------------------------
#- Ciccreator
#-----------------------------------------------------------------------------
#RUN apt-get update -q && \
#    DEBIAN_FRONTEND=noninteractive apt-get install -qy make git && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/*

#- Copied from  https://github.com/rabits/dockerfiles/blob/master/5.4-desktop/Dockerfile
#- Install QT
#RUN apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
#    git \
#    openssh-client \
#    ca-certificates \
#    curl \
#    p7zip \
#    build-essential \
#    pkg-config \
#    libgl1-mesa-dev \
#    libsm6 \
#    libice6 \
#    libxext6 \
#    libxrender1 \
#    libfontconfig1 \
#    && apt-get -qq clean

#Install QT
#ENV DEBIAN_FRONTEND noninteractive
#ENV QT_PATH /opt/Qt
#ENV QT_DESKTOP $QT_PATH/5.4/gcc_64
#ENV PATH $QT_DESKTOP/bin:$PATH

# Download & unpack Qt 5.4 toolchains & clean
#RUN mkdir -p /tmp/qt \
#&& curl -Lo /tmp/qt/installer.run 'https://download.qt.io/new_archive/qt/5.4/5.4.2/qt-opensource-linux-x64-5.4.2.run'
#&& curl -Lo /tmp/qt/installer.run 'http://simvascular.stanford.edu/downloads/public/open_source/linux/qt/5.4/qt-opensource-linux-x64-5.4.2.run'
#

#RUN chmod 755 /tmp/qt/installer.run && /tmp/qt/installer.run --dump-binary-data -o /tmp/qt/data || exit 0;

#RUN mkdir $QT_PATH && cd $QT_PATH \
#    && 7zr x /tmp/qt/data/qt.54.gcc_64/5.4.2-0qt5_essentials.7z > /dev/null \
#    && 7zr x /tmp/qt/data/qt.54.gcc_64/5.4.2-0qt5_addons.7z > /dev/null \
#    && 7zr x /tmp/qt/data/qt.54.gcc_64/5.4.2-0icu_53_1_ubuntu_11_10_64.7z > /dev/null \
#    && /tmp/qt/installer.run --runoperation QtPatch linux $QT_DESKTOP qt5 || exit 0;
    #&& rm -rf /tmp/qt

#WORKDIR /eda
#RUN git clone https://github.com/wulffern/ciccreator.git
#WORKDIR ciccreator
#RUN git checkout develop
#RUN git pull
#RUN make all
#RUN ln -s /eda/ciccreator/bin/linux/cic /usr/bin


#-----------------------------------------------------------------------------
# Setup emacs
#-----------------------------------------------------------------------------

ADD --chown=ciceda:ciceda ./scr/elisp /home/ciceda/elisp
RUN mkdir --parents /eda/install/
COPY --chown=ciceda:ciceda ./scr/install/emacs.sh /eda/install/emacs_install.sh
RUN chmod a+rx /eda/install/emacs_install.sh
COPY ./scr/user/.emacs /home/ciceda/.emacs
RUN chmod ug+rw .emacs
USER ciceda
RUN /eda/install/emacs_install.sh verilog-mode
USER 0


#-----------------------------------------------------------------------------
# Setup Aimspice
#-----------------------------------------------------------------------------
COPY ./aimspice/aimspicec /bin/aimspicec
COPY ./aimspice/aimspicec /bin/aimspice
RUN chmod 755 /bin/aimspicec
RUN chmod 755 /bin/aimspice

#-----------------------------------------------------------------------------
# Setup Python
#-----------------------------------------------------------------------------
RUN pip3 install matplotlib numpy pandas click tikzplotlib pyyaml

#-----------------------------------------------------------------------------
# Setup USER
#-----------------------------------------------------------------------------
COPY --chown=ciceda:ciceda ./scr/user/bashrc .bashrc
COPY --chown=ciceda:ciceda ./scr/user/.dircolors .dircolors
COPY --chown=ciceda:ciceda ./scr/user/.bash_profile .bash_profile

#-----------------------------------------------------------------------------
# Setup Geany
#-----------------------------------------------------------------------------
#RUN apt install geany -y


#-----------------------------------------------------------------------------
# Setup gEda
#-----------------------------------------------------------------------------
#RUN apt install -y geda
#-----------------------------------------------------------------------------
# Setup Code
#-----------------------------------------------------------------------------
#WORKDIR /tmp/
#RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
#RUN install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
#RUN sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
#RUN rm -f packages.microsoft.gpg
#RUN apt install -y apt-transport-https
#RUN apt update --fix-missing
#RUN apt install -y code # or code-insiders


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

#USER 1000
#WORKDIR /headless/eda
USER ciceda
