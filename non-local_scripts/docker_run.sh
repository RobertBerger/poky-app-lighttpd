source ../container-name.sh
IMAGE_NAME=$1
NETWORK_INTERFACE=$2

PUBLIC_PORT="8888"

#TAG="20190420065849-poky-2.7-plus-snapshot"
TAG="latest"

if [ $# -lt 2 ];
then
    echo "+ $0: Too few arguments!"
    echo "+ use something like:"
    echo "+ $0 <docker image> <network interface>"
    echo "+ $0 reliableembeddedsystems/${CONTAINER_NAME}:${TAG} docker0"
    echo "+ $0 reliableembeddedsystems/${CONTAINER_NAME}:${TAG} br0"
    exit
fi

# remove currently running containers
echo "+ ID_TO_KILL=\$(docker ps -a -q  --filter ancestor=$1)"
ID_TO_KILL=$(docker ps -a -q  --filter ancestor=$1)

echo "+ docker ps -a"
docker ps -a
echo "+ docker stop ${ID_TO_KILL}"
docker stop ${ID_TO_KILL}
echo "+ docker rm -f ${ID_TO_KILL}"
docker rm -f ${ID_TO_KILL}
echo "+ docker ps -a"
docker ps -a

# enable TUN device (for qemu)
#echo "+ sudo modprobe tun"
#sudo modprobe tun

# run the image
#echo "+ ID=\$(docker run -v ${HOME}/docker-nonvol-scripts:/home/genius/nonvol-scripts -t -i -d -p 22 --privileged ${IMAGE_NAME} /sbin/my_init -- bash -l)"
#ID=$(docker run -v ${HOME}/docker-nonvol-scripts:/home/genius/nonvol-scripts -t -i -d -p 22 --privileged ${IMAGE_NAME} /sbin/my_init -- bash -l)
#echo "+ ID=\$(docker run -t -i -d -p ${PUBLIC_PORT}:80 --privileged ${IMAGE_NAME} ${APP_IN_IMAGE} -l)"
#ID=$(docker run -t -i -d -p ${PUBLIC_PORT}:80 --privileged ${IMAGE_NAME} ${APP_IN_IMAGE} -l)

# start ash shell - need to start lighttpd manually
#echo "+ ID=\$(docker run -t -i -d -p ${PUBLIC_PORT}:80 --privileged ${IMAGE_NAME} ash -l)"
#ID=$(docker run -t -i -d -p ${PUBLIC_PORT}:80 --privileged ${IMAGE_NAME} ash -l)

echo "+ ID=\$(docker run -t -i -d -p ${PUBLIC_PORT}:80 --privileged ${IMAGE_NAME})"
ID=$(docker run -t -i -d -p ${PUBLIC_PORT}:80 --privileged ${IMAGE_NAME})

echo "+ ID ${ID}"

# ssh stuff:
#PORT=$(docker port ${ID} 22 | awk -F':' '{ print $2 }')
#IPADDR=$(ifconfig ${NETWORK_INTERFACE} | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')
#echo "+ ssh to the container like this:"
#echo "ssh -X genius@${IPADDR} -p ${PORT}"

# let's attach to it:
echo "+ docker attach ${ID}"
docker attach ${ID}

