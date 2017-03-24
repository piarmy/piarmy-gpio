# Experimenting with creating a base Apline/armhf image which includes:
#   * Updates
#   * Base tools
#   * Development tools

FROM armhf/alpine
LABEL maintainer "matt@brightpixel.com"

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

RUN npm install --loglevel verbose -g \
    node-red \
    node-red-node-daemon \
    node-red-contrib-inotify \
    node-red-contrib-cron \
    node-red-node-base64 \
    node-red-node-geohash \
    node-red-node-random \
    node-red-node-smooth \
    node-red-node-suncalc \
    node-red-contrib-flow-dispatcher \
    node-red-contrib-kalman \
    node-red-contrib-msg-resend \
    node-red-contrib-roster \
    node-red-contrib-yield
      
RUN npm install --loglevel verbose -g \
    node-red-contrib-ifttt \
    node-red-node-feedparser \
    node-red-node-twitter \
    node-red-contrib-twitter \
    node-red-contrib-twitter-text \
    node-red-contrib-twitter-stream \
    node-red-contrib-push \
    node-red-contrib-slack \
    node-red-node-pushbullet \
    node-red-node-google \
    node-red-node-twilio \
    node-red-contrib-shorturl \
    node-red-contrib-wit-ai \
    node-red-contrib-cognitive-services \
    node-red-contrib-chatbot \
    node-red-node-wordpos \
    node-red-node-exif \
    node-red-contrib-httpauth \
    node-red-contrib-https \
    node-red-contrib-get-feeds \
    node-red-contrib-rss \
    node-red-contrib-gzip \
    node-red-contrib-markdown

# Testing these individually to see which package breaks
# Will rebundle them into one layer after testing.

RUN npm install --loglevel verbose -node-red-dashboard 
RUN npm install --loglevel verbose -node-red-contrib-graphs
RUN npm install --loglevel verbose -node-red-contrib-metrics
RUN npm install --loglevel verbose -node-red-contrib-n2n
RUN npm install --loglevel verbose -node-red-contrib-zmq
RUN npm install --loglevel verbose -node-red-node-msgpack
RUN npm install --loglevel verbose -node-red-contrib-bigtimer
RUN npm install --loglevel verbose -node-red-contrib-moment
RUN npm install --loglevel verbose -node-red-node-openweathermap

RUN rm -rf /root/.npms

RUN adduser -D -h /home/nodered -s /bin/ash -u 1001 nodered
USER nodered
EXPOSE 1880

# docker run -it --rm -p=1880:1880 mattwiater/alpine-armhf-node-red /bin/ash
# docker run -d --rm -p=1880:1880 mattwiater/alpine-armhf-node-red
# openweather mattwiater / 9e08498990558442ae7d7dfbc0d7ff21

CMD ["node-red"]