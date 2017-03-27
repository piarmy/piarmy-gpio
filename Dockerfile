# Experimenting with creating a base Apline/armhf image which includes:
#   * Updates
#   * Base tools
#   * Development tools
#
# docker run -it --rm -p=1880:1880 mattwiater/alpine-armhf-node-red /bin/ash
# docker run -d --rm -p=1880:1880 mattwiater/alpine-armhf-node-red
#
# Exmaple Flow: Websockets // http://flows.nodered.org/flow/8666510f94ad422e4765
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
    zeromq-dev

# Base
RUN npm install --loglevel verbose -g \
    node-red \
    node-red-node-daemon \
    node-red-node-base64 \
    node-red-node-wordpos \
    node-red-node-exif \
    node-red-node-geohash \
    node-red-node-random \
    node-red-node-smooth \
    node-red-node-suncalc \
    node-red-node-feedparser \
    node-red-node-twitter \
    node-red-node-pushbullet \
    node-red-node-google \
    node-red-node-twilio \
    node-red-node-msgpack \
    node-red-node-openweathermap

# Contribs
RUN npm install --loglevel verbose -g \
    node-red-contrib-inotify \
    node-red-contrib-cron \
    node-red-contrib-flow-dispatcher \
    node-red-contrib-msg-resend \
    node-red-contrib-roster \
    node-red-contrib-yield \
    node-red-contrib-ifttt \
    node-red-contrib-push \
    node-red-contrib-slack \
    node-red-contrib-shorturl \
    node-red-contrib-chatbot \
    node-red-contrib-httpauth \
    node-red-contrib-https \
    node-red-contrib-get-feeds \
    node-red-contrib-rss \
    node-red-contrib-gzip \
    node-red-contrib-markdown \
    node-red-contrib-graphs \
    node-red-contrib-metrics \
    node-red-contrib-n2n \
    node-red-contrib-zmq \
    node-red-contrib-bigtimer \
    node-red-contrib-moment \
    node-red-contrib-socketio \
    node-red-dashboard \
  && rm -rf /root/.npms

#RUN npm install --loglevel verbose -g \
#    npm install node-red-contrib-npm


#RUN adduser -D -h /home/nodered -s /bin/ash -u 1001 nodered
#USER nodered
EXPOSE 1880

CMD ["node-red"]
