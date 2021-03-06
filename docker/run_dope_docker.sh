#!/bin/bash

# Copyright (c) 2018, NVIDIA CORPORATION. All rights reserved.
# Full license terms provided in LICENSE.md file.

CONTAINER_NAME=$1
if [[ -z "${CONTAINER_NAME}" ]]; then
    CONTAINER_NAME=nvidia-dope-v1
fi

# This specifies a mapping between a host directory and a directory in the
# docker container. This mapping should be changed if you wish to have access to
# a different directory
HOST_DIR=$2
if [[ -z "${HOST_DIR}" ]]; then
    HOST_DIR=`realpath ${PWD}/..`
fi

CONTAINER_DIR=$3
if [[ -z "${CONTAINER_DIR}" ]]; then
    CONTAINER_DIR=/root/catkin_ws/src/dope
fi

STORAGE_CONTAINER=/data
STORAGE_HOST=/home/hfebbo/data

echo "Container name     : ${CONTAINER_NAME}"
echo "Host directory     : ${HOST_DIR}"
echo "Container directory: ${CONTAINER_DIR}"
DOPE_ID=`docker ps -aqf "name=^/${CONTAINER_NAME}$"`

docker rm nvidia-dope-v1
echo "Creating new DOPE docker container."
xhost +local:root
nvidia-docker run --ipc=host -it --privileged --network=host -v ${HOST_DIR}:${CONTAINER_DIR}:rw -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v ${STORAGE_HOST}:${STORAGE_CONTAINER}:rw --env="DISPLAY" --name=${CONTAINER_NAME} nvidia-dope:kinetic-v1 bash

#if [ 1 ]; then
# if [ -z "${DOPE_ID}" ]; then
    # echo "Creating new DOPE docker container."
    # xhost +local:root
    # nvidia-docker run --ipc=host -it --privileged --network=host -v ${HOST_DIR}:${CONTAINER_DIR}:rw -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v ${STORAGE_HOST}:${STORAGE_CONTAINER}:rw --env="DISPLAY" --name=${CONTAINER_NAME} nvidia-dope:kinetic-v1 bash
# else
#     echo "Found DOPE docker container: ${DOPE_ID}."
#     # Check if the container is already running and start if necessary.
#     if [ -z `docker ps -qf "name=^/${CONTAINER_NAME}$"` ]; then
#         xhost +local:${DOPE_ID}
#         echo "Starting and attaching to ${CONTAINER_NAME} container..."
#         docker start ${DOPE_ID}
#         docker attach ${DOPE_ID}
#     else
#         echo "Found running ${CONTAINER_NAME} container, attaching bash..."
#         docker exec -it ${DOPE_ID} bash
#     fi
# fi
