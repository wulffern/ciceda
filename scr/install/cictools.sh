#!/usr/bin/env bash
set -euo pipefail


git clone https://github.com/wulffern/cicpacgen.git
pip install ./cicpacgen -e

git clone https://github.com/wulffern/cicsim.git
pip install ./cicsim -e

git clone https://github.com/wulffern/cicpy.git
pip install ./cicpy -e

git clone https://github.com/wulffern/ciccheatgen.git
