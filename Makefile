######################################################################
##        Copyright (c) 2020 Carsten Wulff Software, Norway
## ###################################################################
## Created       : wulff at 2020-11-27
## ###################################################################
##  The MIT License (MIT)
##
##  Permission is hereby granted, free of charge, to any person obtaining a copy
##  of this software and associated documentation files (the "Software"), to deal
##  in the Software without restriction, including without limitation the rights
##  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
##  copies of the Software, and to permit persons to whom the Software is
##  furnished to do so, subject to the following conditions:
##
##  The above copyright notice and this permission notice shall be included in all
##  copies or substantial portions of the Software.
##
##  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
##  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
##  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
##  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
##  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
##  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
##  SOFTWARE.
##
######################################################################

DATE = $(shell date +%Y-%m-%d)
TAG = develop_0.2.0

build_ubuntu:
	docker build  -t wulffern/ciceda:ubuntu_${TAG} -f ubuntu/Dockerfile .

.PHONY:eda
eda:
	docker run --rm -it  -v  `pwd`/eda:/home/ciceda/copy -u root  -i wulffern/ciceda:ubuntu_${TAG} rsync -va /opt/eda/ /home/ciceda/copy/


tagpush:
	docker tag wulffern/ciceda:ubuntu_latest wulffern/ciceda:ubuntu_${TAG}
	docker push wulffern/ciceda:ubuntu_${TAG}
	#docker push wulffern/ciceda:ubuntu_latest



run:
	docker run --rm -it -p 5900:5900 -v `pwd`:/home/ciceda/pro -i wulffern/ciceda:ubuntu_${TAG} bash --login

runroot:
	docker run --rm -it --user 0 -p 5900:5900 -v `pwd`:/home/ciceda/pro -i wulffern/ciceda:ubuntu_${TAG} bash --login
