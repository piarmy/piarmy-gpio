# /bin/bash

docker rm --force $(docker ps | awk '/piarmy-gpio/{ print $1 }') && \
  docker build -t mattwiater/piarmy-gpio .  && \
  docker run -d --rm --privileged --network host --cap-add SYS_RAWIO --device /dev/mem -p:1880:1880 --name=piarmy-gpio mattwiater/piarmy-gpio && \
  image=$(docker ps | awk '/piarmy-gpio/{ print $1 }') && \
  echo $image

docker commit $image mattwiater/piarmy-gpio
docker push mattwiater/piarmy-gpio
docker rm --force $image