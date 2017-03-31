# Alpine-armhf-node-red

#### Premise
---
Built from the base [armhf/alpine](https://hub.docker.com/r/armhf/alpine/), this image includes support for:
* Development (Tools and dependencies, i.e. alpine-sdk, binutils, gcc, etc.)
* [Mosquitto MQTT Broker](https://mosquitto.org/)
* [RPi.GPOI(]https://pypi.python.org/pypi/RPi.GPIO)
* [PM2](http://pm2.keymetrics.io/) for starting services in container at runtime viapm2-docker
* [OpenZwave](https://github.com/OpenZWave/open-zwave) compile and run within the docker container
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
  - script   : '/usr/sbin/mosquitto'
    args     : '-v -c  /mqtt/config/mosquitto.conf'
```

I've kept this separate as it is directly linked to the CMD statement of the Dockerfile and can be edited outside of the image--although you have to rebuild...

`CMD ["pm2-docker", "/home/process.yml"]`

#### Run
---
As of now, outside of some hacks, it's difficult to run these as part of a Swarm due to the reliance on the --device switch which maps devices from the host to the container (See: https://github.com/docker/swarmkit/issues/1244).

##### Devices
Docker run parameters for access to GPIO Pins:
```
--cap-add SYS_RAWIO
--device /dev/mem
```

Docker run parameters for access to OpenZwave:
```
--device /dev/ttyUSB0
```

##### Ports
```
1880 # Node Red
1883 # MQTT
9001 # MQTT Websockets
```

Interactive Mode:
```
docker run -it --rm --network piarmy --cap-add SYS_RAWIO --device /dev/mem --device /dev/ttyUSB0 -p 1883:1883 -p 9001:9001 -p:1880:1880 --name=alpine-armhf-node-red mattwiater/alpine-armhf-node-red /bin/bash
```

Detached Mode:
```
docker run -d --rm --network piarmy --cap-add SYS_RAWIO --device /dev/mem --device /dev/ttyUSB0 -p 1883:1883 -p 9001:9001 -p:1880:1880 --name=alpine-armhf-node-red mattwiater/alpine-armhf-node-red
```