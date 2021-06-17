#!/usr/bin/env bash
set -euo pipefail

apt install -y python3-pip

git clone https://github.com/wulffern/cicpacgen.git
pip install ./cicpacgen

git clone https://github.com/wulffern/cicsim.git
pip install ./cicsim

#git clone https://github.com/wulffern/cicpy.git
#pip install ./cicpy

git clone https://github.com/wulffern/ciccheatgen.git
