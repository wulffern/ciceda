#FROM centos:centos7
FROM consol/ubuntu-xfce-vnc:1.4.0
ENV REFRESHED_AT 2018-03-18

# Switch to root user to install additional software
USER 0

#- install eda tools
RUN apt-get update -y
RUN apt-get install -y iverilog ngspice gtkwave xcircuit gwave

RUN apt-get install -y make git

RUN mkdir /home/headless

USER 1000
