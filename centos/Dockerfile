
FROM centos:centos7

# Switch to root user to install additional software
USER 0

RUN yum install epel-release -y
RUN yum update -y

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
#- Install VNC Server
#-----------------------------------------------------------------------------
RUN yum install -y tigervnc-server
RUN yum install -y xterm sudo
RUN yum install -y lxqt* --exclude=lxqt-*-devel

USER ciceda
RUN   echo -e 'ciceda\nciceda\n' | vncpasswd
COPY --chown=ciceda:ciceda ./centos/xstartup .vnc/xstartup
RUN chmod 755 .vnc/xstartup
COPY --chown=ciceda:ciceda  ./centos/vncstart vncstart
RUN chmod 755 vncstart
USER 0
EXPOSE 5900


#-----------------------------------------------------------------------------
#- Install EDA tools
#-----------------------------------------------------------------------------
RUN yum install -y iverilog gtkwave make git

#-----------------------------------------------------------------------------
# Install emacs
#-----------------------------------------------------------------------------
RUN yum install -y emacs

ADD --chown=ciceda:ciceda ./scr/elisp /home/ciceda/elisp
RUN mkdir --parents /eda/install/
COPY ./scr/install/emacs.sh /eda/install/emacs_install.sh
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
RUN yum -y install python36-tkinter
USER ciceda
RUN pip3 install --user matplotlib numpy pandas click
USER 0

#-----------------------------------------------------------------------------
# Setup USER
#-----------------------------------------------------------------------------
COPY --chown=ciceda:ciceda ./scr/user/bashrc .bashrc
COPY --chown=ciceda:ciceda ./scr/user/.dircolors .dircolors
COPY --chown=ciceda:ciceda ./scr/user/.bash_profile .bash_profile
USER ciceda

USER 0
RUN yum install -y glibc

USER ciceda
