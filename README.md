# alpine-armhf-node-red

# Interactive mode (testing)
docker run -it --rm -p:1880:1880 --name=alpine-armhf-node-red mattwiater/alpine-armhf-node-red /bin/bash

# Interactive mode with USB Device (testing)
docker run -it --rm -p:1880:1880 --device=/dev/ttyAMA0 --name=alpine-armhf-node-red mattwiater/alpine-armhf-node-red /bin/bash

# Regular mode
docker run -d --rm -p:1880:1880 --name=alpine-armhf-node-red mattwiater/alpine-armhf-node-red