
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
    apt-get install -y --no-install-recommends tigervnc-standalone-server xvfb dbus-x11 x11-utils && \
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
RUN apt-get update -q && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends libqt5core5a && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --chown=ciceda:ciceda ./tools/cic.linux_0.1.2 /bin/cic
RUN chmod 755 /bin/cic


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
# Setup text editors
#-----------------------------------------------------------------------------
RUN apt-get update -q && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends gedit nano geany    && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


#-----------------------------------------------------------------------------
#- Workcraft
#-----------------------------------------------------------------------------
RUN cd /tmp; wget https://workcraft.org/_media/download/workcraft-v3.3.4-linux.tar.gz

#-----------------------------------------------------------------------------
# Setup gEda
#-----------------------------------------------------------------------------
#RUN apt install -y geda

#-----------------------------------------------------------------------------
# Setup Code
#-----------------------------------------------------------------------------
#WORKDIR /tmp/
#RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
#    install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ &&\
#    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' &&\
#    apt-get update -q && \
#    apt-get install -y apt-transport-https &&\
#    apt update && \
#    apt install code &&\
#    apt-get autoclean -y && \
#    apt-get autoremove -y && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/*


#-----------------------------------------------------------------------------
# Setup Code
#-----------------------------------------------------------------------------

WORKDIR /eda
RUN git clone https://github.com/wulffern/cicpacgen.git && \
    pip install -e ./cicpacgen  && \
    git clone https://github.com/wulffern/cicsim.git    && \
    pip install -e ./cicsim  && \
    git clone https://github.com/wulffern/cicpy.git && \
    pip install -e ./cicpy  && \
    git clone https://github.com/wulffern/ciccheatgen.git &&\
    git clone https://github.com/wulffern/ciccreator

WORKDIR /home/ciceda
RUN mkdir .vnc && chown ciceda:ciceda .vnc
COPY --chown=ciceda:ciceda ./scr/user/xstartup .vnc/xstartup
RUN chmod 755 .vnc/xstartup


#-----------------------------------------------------------------------------
# Setup octave
#-----------------------------------------------------------------------------
RUN apt-get update -q && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y octave    && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#USER 1000
WORKDIR /home/ciceda
USER ciceda
