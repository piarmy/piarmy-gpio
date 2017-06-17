# /bin/bash

docker rm --force $(docker ps | awk '/piarmy-gpio/{ print $1 }') || echo "No running image..." && \
  docker build -t mattwiater/piarmy-gpio .  && \
  docker run -d --rm --privileged --network host -p:1880:1880 --name=piarmy-gpio mattwiater/piarmy-gpio && \
  image=$(docker ps | awk '/piarmy-gpio/{ print $1 }') && \
  echo $image

docker commit $image mattwiater/piarmy-gpio
docker push mattwiater/piarmy-gpio
docker rm --force $image

docker run -d --restart=unless-stopped --privileged --network host -p:1880:1880 --name=piarmy-gpio mattwiater/piarmy-gpio