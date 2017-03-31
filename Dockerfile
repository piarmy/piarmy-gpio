# Experimenting with creating a base Apline/armhf image which includes:
#   * Updates
#   * Base tools
#   * Development tools
#
# docker run -it --rm -p=1880:1880 -p=1883:1883 -p=9001:9001 mattwiater/alpine-armhf-node-red /bin/ash
# docker run -d --rm -p=1880:1880 -p=1883:1883 -p=9001:9001 mattwiater/alpine-armhf-node-red
#
# Example Flow: Websockets // http://flows.nodered.org/flow/8666510f94ad422e4765
# http://{server}:1880/simple

FROM armhf/alpine
LABEL maintainer "matt@brightpixel.com"

# Toolsets
RUN apk update && apk upgrade && \
  apk add alpine-sdk && \
  apk add bash bash-doc bash-completion && \
  apk add nano && \
  apk add util-linux pciutils usbutils coreutils findutils grep && \
  apk add build-base gcc abuild binutils binutils-doc gcc-doc && \
  apk add man man-pages

# Node Red Dockerfile
# https://github.com/rcarmo/docker-node-red/blob/master/alpine/Dockerfile
#

# Dev Toolsets
RUN apk update \
  && apk upgrade \
  && apk add --no-cache \
    musl-dev \
    libc-dev \
    build-base \
    ca-certificates \
    supervisor \
    nodejs \
    nodejs-dev \
    zeromq-dev \
    mosquitto \
    py-rpigpio \
    openrc

# Base
RUN npm install --loglevel verbose -g \
    node-red \
    node-red-node-daemon \
    node-red-node-base64 \
    node-red-node-wordpos \
    node-red-node-geohash \
    node-red-node-random \
    node-red-node-smooth \
    node-red-node-suncalc \
    node-red-node-msgpack \
    node-red-node-openweathermap \
    pm2

# Contribs
RUN npm install --loglevel verbose -g \
    node-red-contrib-inotify \
    node-red-contrib-cron \
    node-red-contrib-flow-dispatcher \
    node-red-contrib-httpauth \
    node-red-contrib-https \
    node-red-contrib-gzip \
    node-red-contrib-graphs \
    node-red-contrib-metrics \
    node-red-contrib-n2n \
    node-red-contrib-zmq \
    node-red-contrib-bigtimer \
    node-red-contrib-moment \
    node-red-contrib-socketio \
    node-red-dashboard \
  && rm -rf /root/.npms

ADD process.yml /home/process.yml

RUN mkdir -p /mqtt/config /mqtt/data /mqtt/log && chown mosquitto:mosquitto /mqtt/*
COPY config /mqtt/config
VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]

EXPOSE 1883 9001 1880

#docker run -d --rm --network piarmy --cap-add SYS_RAWIO --device /dev/mem -p 1883:1883 -p 9001:9001 -p:1880:1880 --name=alpine-armhf-node-red mattwiater/alpine-armhf-node-red

CMD ["pm2-docker", "/home/process.yml"]