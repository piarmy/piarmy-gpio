# rpi-node-red-gpio

#### Premise
---
Built from the base [armhf/alpine](https://hub.docker.com/r/armhf/alpine/), this image includes support for:
* Development (Tools and dependencies, i.e. alpine-sdk, binutils, gcc, etc.)
* [RPi.GPOI(]https://pypi.python.org/pypi/RPi.GPIO)
* [PM2](http://pm2.keymetrics.io/) for starting services in container at runtime viapm2-docker
* Node Red
  * Common Base Nodes
  * Useful Contrib Packages

All of these are built into the image itself and available at runtime.

#### Configs
---
Most configs are contained within the image, with the exceptions of the config.yml file for PM2: `/home/process.yml`

```
apps:
  - script   : 'node-red'
    name     : 'Node Red'
```

I've kept this separate as it is directly linked to the CMD statement of the Dockerfile and can be edited outside of the image--although you have to rebuild...

`CMD ["pm2-docker", "/home/process.yml"]`

#### Build
---
```
docker build -t mattwiater/rpi-node-red-gpio .
docker run -d --rm --network piarmy --cap-add SYS_RAWIO --device /dev/mem -p:1880:1880 --name=rpi-node-red-gpio mattwiater/rpi-node-red-gpio
docker commit <imageid> mattwiater/rpi-node-red-gpio
docker push mattwiater/rpi-node-red-gpio
```

#### Layers
---
This image is for development, and therefore has a plethora of OS toolsets, node red contribs, etc. You can probably compress this image a bit by removing any packages you're not planning on using. This build weighs in around: 432 MB

`docker history mattwiater/rpi-node-red-gpio`

```
73f1ba422a8b        3 minutes ago       pm2-docker /home/process.yml                    34.3 kB             
12b2e89738e0        6 minutes ago       /bin/sh -c #(nop)  CMD ["pm2-docker" "/hom...   0 B                 
433593683fb4        6 minutes ago       /bin/sh -c #(nop)  EXPOSE 1880/tcp              0 B                 
64c918fd165f        7 minutes ago       /bin/sh -c #(nop) ADD file:6abcdd1313a8859...   57 B                
3b7667c59b07        7 minutes ago       /bin/sh -c npm install --loglevel verbose ...   170 MB              
b3ea2633105d        14 minutes ago      /bin/sh -c apk update && apk upgrade &&   ...   258 MB              
a37c9a4f9b5a        19 minutes ago      /bin/sh -c #(nop)  LABEL maintainer=matt@b...   0 B                 
021f2812f6b7        17 hours ago        /bin/sh -c #(nop) ADD file:332cb85fb3d17b6...   3.6 MB
```

#### Run
---
As of now, outside of some hacks, it's difficult to run these as part of a Swarm due to the reliance on the --device switch which maps devices from the host to the container (See: https://github.com/docker/swarmkit/issues/1244).

##### Devices
Docker run parameters for access to GPIO Pins:
```
--cap-add SYS_RAWIO
--device /dev/mem
```

##### Ports
```
1880 # Node Red
```

Interactive Mode:
```
docker run -it --rm --network piarmy --cap-add SYS_RAWIO --device /dev/mem -p:1880:1880 --name=rpi-node-red-gpio mattwiater/rpi-node-red-gpio /bin/bash
```

Detached Mode:
```
docker run -d --rm --network piarmy --cap-add SYS_RAWIO --device /dev/mem -p:1880:1880 --name=rpi-node-red-gpio mattwiater/rpi-node-red-gpio
```