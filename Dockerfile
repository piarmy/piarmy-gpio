# Experimenting with creating a base Apline/armhf image which includes:
#   * Updates
#   * Base tools
#   * Development tools
#

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
    node-red-node-msgpack \
    node-red-contrib-inotify \
    node-red-contrib-cron \
    node-red-contrib-flow-dispatcher \
    node-red-contrib-httpauth \
    node-red-contrib-https \
    node-red-contrib-gzip \
    node-red-contrib-graphs \
    node-red-contrib-metrics \
    node-red-contrib-n2n \
    node-red-contrib-bigtimer \
    node-red-contrib-moment \
    node-red-contrib-under-query \
    node-red-dashboard \
  && rm -rf /root/.npms

####################
# PM2 Config
COPY ["container_files/settings.js", "container_files/ws.json", "container_files/process.yml", "/root/.node-red/"]

####################
# Ports
EXPOSE 1880

CMD ["pm2-docker", "/root/.node-red/process.yml"]
