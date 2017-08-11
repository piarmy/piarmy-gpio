# piarmy-gpio

#### This is currently in progress. This notice will be removed when ready for deployment and documentation is updated. Assume unusable nonsense below.

## Notes
docker run -d --restart=always --privileged --network host --cap-add SYS_RAWIO --device /dev/mem -p:1880:1880 --name=piarmy-gpio mattwiater/piarmy-gpio
