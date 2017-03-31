# Experimenting with creating a base Apline/armhf image which includes:
#   * Updates
#   * Base tools
#   * Development tools
#
# Example Flow: Websockets // http://flows.nodered.org/flow/8666510f94ad422e4765
# http://{server}:1880/simple

FROM armhf/alpine
LABEL maintainer "matt@brightpixel.com"

####################
# Toolsets
RUN apk update && apk upgrade && \
  apk add alpine-sdk \
    bash bash-doc bash-completion \
    nano \
    util-linux pciutils usbutils coreutils findutils grep \
    build-base gcc abuild binutils binutils-doc gcc-doc \
    linux-headers \
    eudev-dev \
    man man-pages \
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

####################
# NPM Modules
# Node Red Nodes and Contrib
RUN npm install --loglevel verbose -g \
    pm2 \
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

####################
# PM2 Config
ADD process.yml /home/process.yml

####################
# Open Zwave
RUN git clone https://github.com/OpenZWave/open-zwave.git /usr/src/open-zwave && \
  cd /usr/src/open-zwave && \
  make && \
  make install && \
  npm install --loglevel verbose -g node-red-contrib-openzwave

####################
# Mosquitto
RUN mkdir -p /mqtt/config /mqtt/data /mqtt/log && chown mosquitto:mosquitto /mqtt/*
COPY config /mqtt/config
VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]

####################
# Ports
EXPOSE 1883 9001 1880

CMD ["pm2-docker", "/home/process.yml"]