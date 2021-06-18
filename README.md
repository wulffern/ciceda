# ciceda (Custom IC EDA)

Getting started with SPICE and verilog can be a daunting task. Companies that
make integrated circuits spend millions on Electronic Design Assistance (EDA)
tools, and even then, the truth is, they are not great. 

So, expecting open source EDA tools to be a polished, easy to use, easy to learn
tools is too much to ask.

Luckliy, at the beginning of the integrated circuit journey we don't need the
full blown comercial tools. At the beginning, we need to understand the
principles of SPICE, Verilog, how to write the files, how to run the
simulations, and how to view the results.

The difference between open source EDA tools and the commercial tools is that it's
easier to make complex systems with the commercial tools, and believe me, ICs are very complex.

For now though, let's focus on the transistors, resistor,  and the
building blocks for digital circuits, the digital gates.

# Tools

## Docker
Docker is something you must know about. It is a really good way to create small
virtual machines on any platform. https://www.docker.com


## Ngspice SPICE Simulator
ngspice is the open source spice simulator for electric and electronic circuits.
See more at http://ngspice.sourceforge.net

## Icarus Verilog Simulator
Icarus Verilog is a Verilog simulation and synthesis tool. It operates as a
compiler, compiling source code written in Verilog (IEEE-1364) into some target
format. For batch simulation, the compiler can generate an intermediate form
called vvp assembly. This intermediate form is executed by the ``vvp'' command.
For synthesis, the compiler generates netlists in the desired format.

http://iverilog.icarus.com
https://iverilog.fandom.com/wiki/

## GTKWave
GTKWave is a fully featured GTK+ based wave viewer for Unix, Win32, and Mac OSX
which reads LXT, LXT2, VZT, FST, and GHW files as well as standard Verilog
VCD/EVCD files and allows their viewing. Documentation in pdf format can be
found http://gtkwave.sourceforge.net/gtkwave.pdf.
http://gtkwave.sourceforge.net


# Getting started

Install docker from [docker.com](http://docker.com)

Clone this repository

``` sh
git clone https://github.com/wulffern/ciceda
```
  
## MacOS
Start ciceda 

``` sh
./ciceda_mac.sh
```

Which runs the command 

``` sh
docker run -it -p 5901:5901 -e VNC_RESOLUTION=1920x1080 -e VNC_PW=ciceda  -v `pwd`/:/headless/eda wulffern/ciceda:0.2.0 bash
```

In finder, select Go -> Connect to server and enter vnc://localhost:5901,
password ciceda


# Examples

## SPICE
There are a few examples in ~/eda/spice/, for example 
``` sh
cd ~/eda/spice/NCHIO
ngspice tb_nchio.spi
```


  
## Verilog
Examples for verilog are in ~/eda/verilog, for example
``` sh
cd ~/eda/verilog/
```
 
Start waveform viewer
``` sh
gtkwave &
```

Run simulation
``` sh
make
```

  
  
In GTKWave, File -> Open New Tab. Find counter/test.vcd


# Support
I would try carsten@ntnu.no, however, I get about 100 emails per day, so my
response rate is not great. 



