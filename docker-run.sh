#!/bin/bash

DKNAME=opencv3
DKUSER=jovyan
DKHOME=/home/${DKUSER}
PWD=`pwd`
WD="${PWD}"
IMAGE=jnishii/docker-anaconda3-opencv3

DKOPT="--rm \
	-h ${DKNAME} \
	--name ${DKNAME} \
	-v "${WD}":/${DKHOME} \
	-p 8888:8888"

# docker run: 
# --hostname , -h : Container host name
# --detach, -d : Run container in background and print container ID
# -it  :  Allocate pseudo-TTY;  creating an interactive bash shell
# --name : Assign name
# --rm : Automatically remove the container when it exits
#
# https://docs.docker.com/engine/reference/commandline/run/#examples

runX(){
	IP=`ipconfig getifaddr en0`

	echo "running X server and bash ..."
	echo ""
	echo "If you want to connet X server on Docker, run X client on your system."
	echo "  On Mac, follow the instruction below before running this script."
	echo "  1. Start XQuartz and run socat on the terminal of XQuartz."
	echo "  2. $ socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"${DISPLAY}\""
	echo "  3. open another terminal of XQuartz and run this script."
	
	xhost ${IP}

	docker run -it \
		${DKOPT} \
		-e XMODIFIERS \
		-e DISPLAY=${IP}:0 \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		${IMAGE} /bin/bash

	xhost -
}

runX