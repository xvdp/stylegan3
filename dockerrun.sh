#!/bin/bash
# @xvdp - script to simiplify dockerrun sharing xauth for GL - to handle modifications of Dockerfile or Dockerfile_with_user
# usages:

## RUN INFO

## 1. to run as bash, supports visualizer.py or image generation
# ./dockerrun.sh

## 2. to open visualizer.py
# ./dockerrun.sh python visualizer.py

# 3. to generate images as per README example
# ./dockerrun.sh gen_images.py --outdir=out --trunc=1 --seeds=2 \
#         --network=https://api.ngc.nvidia.com/v2/models/nvidia/research/stylegan3/versions/1/files/stylegan3-r-afhqv2-512x512.pkl


## ARGS ysed for local display
# -e DISPLAY=unix$DISPLAY    
# -v /tmp/.docker.xauth:/tmp/.docker.xauth:rw -v /tmp/.X11-unix:/tmp/.X11-unix  -e XAUTHORITY=/tmp/.docker.xauth  # shares X11 xauth and sets environment
# -v /dev:/dev  #       shares devices folder with docker to alow libGL load device info

TAG=stylegan3_user

# run with gl capabilities, bash (if nor args) or visualizer.py
if [[ ($# -gt 1 && $2 == "visualizer.py") || $# == 0 ]]; then
    if [ $# -gt 0 ]; then
        args="$@"
    else
        args=/bin/bash
    fi
    # share local host display and Xauthority : linux only, localhost docker only -
    touch /tmp/.docker.xauth && xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f /tmp/.docker.xauth nmerge -

    echo "docker run --gpus all -it --rm --user $(id -u):$(id -g) -e DISPLAY=unix${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix -v /tmp/.docker.xauth:/tmp/.docker.xauth:rw -e XAUTHORITY=/tmp/.docker.xauth -v /dev:/dev -v `pwd`:/scratch --workdir /scratch -e HOME=/scratch $TAG ${args}"
    docker run --gpus all -it --rm --user $(id -u):$(id -g) -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /tmp/.docker.xauth:/tmp/.docker.xauth:rw -e XAUTHORITY=/tmp/.docker.xauth -v /dev:/dev -v `pwd`:/scratch --workdir /scratch -e HOME=/scratch $TAG $args
else
    # run without GL capabilites
    docker run --gpus all -it --rm --user $(id -u):$(id -g) -v `pwd`:/scratch --workdir /scratch -e HOME=/scratch $TAG $@
fi
