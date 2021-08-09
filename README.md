# ciceda (Custom IC EDA)

Docker image for EDA design

# Installed Tools ciceda:ubuntu_latest

For absolute latest info, see the ubuntu/Dockerfile

Tools:

- **AIM-Spice** free SPICE simulator [aimspice.com](http://aimspice.com)
- **iverilog** free verilog simulator [Icarus Verilog](http://iverilog.icarus.com)
- **GTKWave** free wavform viewer [gtkwave.sourceforge.net](http://gtkwave.sourceforge.net)  
- **ngspice** free SPICE simulator
  [ngspice.sourceforge.net](http://ngspice.sourceforge.net)
- **python3** Python programming language [python.org](http://python.org)
  - matplotlib: plot graphs in python
  - numpy: maths on vectors
  - pandas: maths on tables
  - click: command line interface 
  - tikzplotlib: Convert matplotlib graphs to tikz (for latex)
- **Text Editors**:
  - emacs
  - vim
  - nano
  - geany
  - gedit
- **custom IC creator tools** (stuff I've made)
    - cic: ASCII to layout generator [https://github.com/wulffern/ciccreator](https://github.com/wulffern/ciccreator)
    - cicpacgen: package outline generator
    [https://github.com/wulffern/cicpacgen](https://github.com/wulffern/cicpacgen)
    - cicsim: Simulation orchestration
      [https://github.com/wulffern/cicsim](https://github.com/wulffern/cicsim)
    - cicpy: Python frontend to cic
      [https://github.com/wulffern/cicpy](https://github.com/wulffern/cicpy)
    - ciccheatgen: Cheat sheet generator [https://github.com/wulffern/ciccheatgen](https://github.com/wulffern/ciccheatgen)
- **octave* free matlab

# Getting started

Look in the Makefile, and the ubuntu/Dockerfile 

To test ciceda, do

``` sh
docker run --rm -it -p 5900:5900 -v `pwd`:/home/ciceda/pro -i wulffern/ciceda:ubuntu_latest bash --login
```

``` sh
ciceda@~$ vncserver :0
```

And connect with a VNC viewer

# Support
I would try carsten@ntnu.no, however, I get about 100 emails per day, so my
response rate is not great. 



