# alpine-armhf-node-red

# Interactive mode (testing)
docker run -it --rm -p:1880:1880 --name=alpine-armhf-node-red mattwiater/alpine-armhf-node-red /bin/bash

# Interactive mode with USB Device (testing)
docker run -it --rm -p:1880:1880 --device=/dev/ttyAMA0 --name=alpine-armhf-node-red mattwiater/alpine-armhf-node-red /bin/bash

# Regular mode
docker run -d --rm -p:1880:1880 --name=alpine-armhf-node-red mattwiater/alpine-armhf-node-red

# Service mode
docker service create \
  --name=pa-nod-red-piarmy01 \
  --network=piarmy \
  --constraint=node.labels.name==piarmy01 \
  -p 1880:1880 \
    mattwiater/alpine-armhf-node-red:latest

# Alpine Package Search: https://pkgs.alpinelinux.org/contents?file=videodev2.h&path=&name=&branch=&repo=&arch=armhf

# https://github.com/fsphil/fswebcam/blob/master/README
apk add gd-dev

pjproject-dev
linux-headers

Makefile Changes
gzip -c --best fswebcam.1 > fswebcam.1.gz
gzip -c -1 fswebcam.1 > fswebcam.1.gz

