
FROM ubuntu:groovy
    MAINTAINER Carsten Wulff <carsten@wulff.no>
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
    apt-get install -y --no-install-recommends xvfb dbus-x11 x11-utils && \
    apt-get install -y --no-install-recommends tightvncserver xvfb dbus-x11 x11-utils && \
    apt-get install -y --no-install-recommends xfonts-base xfonts-75dpi xfonts-100dpi && \
    apt-get install -y --no-install-recommends python3-pip python3-dev  && \
    apt-get install -y --no-install-recommends libssl-dev && \
    apt-get install -y --no-install-recommends xterm xfce4-terminal sudo && \
    apt-get purge -y pm-utils xscreensaver* && \
    apt-get install -y  ngspice xcircuit yosys make git emacs libreadline-dev && \
    apt-get install -y xfce4 && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

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


#Needed for tigervnc, Tiger does not work well on windows
#apt-get install -y tigervnc-standalone-server  tigervnc-common &&\
#RUN echo "\$localhost=\"no\"" > /etc/vnc.conf
EXPOSE 5900



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

RUN cd /opt && git clone https://github.com/wulffern/eda.git
COPY --chown=ciceda:ciceda ./tools/cic.linux_0.1.2 /opt/eda/bin/cic
RUN chmod 755 /opt/eda/bin/cic


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
COPY ./aimspice/aimspicec /opt/eda/bin/aimspicec
COPY ./aimspice/aimspicec /opt/eda/bin/aimspice
RUN chmod 755 /opt/eda/bin/aimspicec
RUN chmod 755 /opt/eda/bin/aimspice

#-----------------------------------------------------------------------------
# Setup Python
#-----------------------------------------------------------------------------
RUN pip3 install matplotlib numpy pandas click tikzplotlib pyyaml pygame

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
#RUN cd /tmp; wget https://workcraft.org/_media/download/workcraft-v3.3.4-linux.tar.gz

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

WORKDIR /tmp
RUN mkdir compile
WORKDIR /tmp/compile

#-----------------------------------------------------------------------------
# Compile gtkwave
#-----------------------------------------------------------------------------
RUN wget https://sourceforge.net/projects/gtkwave/files/gtkwave-3.3.104/gtkwave-3.3.104.tar.gz/download
RUN tar zxvf download

RUN  apt-get update -q && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y libjudy-dev && \
    apt-get install -y libbz2-dev && \
    apt-get install -y liblzma-dev && \
    apt-get install -y libgconf2-dev && \
    apt-get install -y libgtk2.0-dev && \
    apt-get install -y tcl-dev  && \
    apt-get install -y tk-dev && \
    apt-get install -y gperf && \
    apt-get install -y gtk2-engines-pixbuf && \
    apt-get install -y bison flex && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cd gtkwave-3.3.104 && ./configure --prefix /opt/eda --disable-tcl --disable-xy && make && make install

#-----------------------------------------------------------------------------
# Compile iverilog
#-----------------------------------------------------------------------------

RUN git clone https://github.com/steveicarus/iverilog.git
RUN cd iverilog && git checkout v11_0 && sh autoconf.sh && ./configure --prefix /opt/eda && make && make install


#-----------------------------------------------------------------------------
# Compile ngspice
#-----------------------------------------------------------------------------
RUN wget https://sourceforge.net/projects/ngspice/files/ng-spice-rework/34/ngspice-34.tar.gz/download
RUN tar zxvf download.1
RUN  apt-get update -q && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y libxaw7-dev  && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cd ngspice-34 && ./configure --with-x  --disable-debug --with-readline=no --prefix /opt/eda && make && make install


#-----------------------------------------------------------------------------
# Compile yosys
#-----------------------------------------------------------------------------
RUN git clone https://github.com/YosysHQ/yosys.git && cd yosys && git checkout yosys-0.9
RUN cd yosys && make config-gcc && make PREFIX=/opt/eda && make install PREFIX=/opt/eda


RUN rm -rf /tmp/compile

WORKDIR /home/ciceda
USER ciceda
