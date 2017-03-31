# alpine-armhf-node-red

# Interactive mode (testing)
docker run -it --rm --network piarmy --cap-add SYS_RAWIO --device /dev/mem -p 1883:1883 -p 9001:9001 -p:1880:1880 --name=alpine-armhf-node-red mattwiater/alpine-armhf-node-red /bin/bash

# Regular mode
docker run -d --rm --network piarmy --cap-add SYS_RAWIO --device /dev/mem -p 1883:1883 -p 9001:9001 -p:1880:1880 --name=alpine-armhf-node-red mattwiater/alpine-armhf-node-red

# Alpine Package Search: https://pkgs.alpinelinux.org/contents?file=videodev2.h&path=&name=&branch=&repo=&arch=armhf

# https://github.com/fsphil/fswebcam/blob/master/README
apk add --no-cache gd-dev
apk add --no-cache pjproject-dev
apk add --no-cache linux-headers

cd /home
git clone https://github.com/fsphil/fswebcam.git
cd fswebcam
./configure

Makefile Changes
gzip -c --best fswebcam.1 > fswebcam.1.gz
gzip -c -1 fswebcam.1 > fswebcam.1.gz

make
make install

# Test
fswebcam -d /dev/video0 -F 1 test.jpg

# Video
apk add ffmpeg

# Test
ffmpeg -t 10 -f v4l2 -framerate 25 -i /dev/video0 output.mkv