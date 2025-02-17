# Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

# INFO FROM Original branch 
# docker build --tag stylegan3 .

    # # Run the gen_images.py script using Docker:
    # docker run --gpus all -it --rm --user $(id -u):$(id -g) \
    #     -v `pwd`:/scratch --workdir /scratch -e HOME=/scratch \
    #     stylegan3 \
    #     python gen_images.py --outdir=out --trunc=1 --seeds=2 \
    #         --network=https://api.ngc.nvidia.com/v2/models/nvidia/research/stylegan3/versions/1/files/stylegan3-r-afhqv2-512x512.pkl

    # original docker instructions ask to run as 
    # docker run --gpus all -it --rm --user $(id -u):$(id -g) -v `pwd`:/scratch --workdir /scratch -e HOME=/scratch --entrypoint /bin/bash stylegan3

    # if python visualizer.py is run 
    # /opt/conda/lib/python3.8/site-packages/glfw/__init__.py:916: GLFWError: (65544) b'X11: The DISPLAY environment variable is missing'

# -----------------------------------
# @xvdp modifications to make python visualizer.py work in local docker (remote server require a bit more finageling)

## BUILD INFO
# docker build --tag stylegan3 .


## RUN INFO
# ./dockerrun.sh included to simplify arguments see dockerrun.sh

## 1. to run as bash, supports visualizer.py or image generation
# ./dockerrun.sh

## 2. to open visualizer.py
# ./dockerrun.sh python visualizer.py

# 3. to generate images as per README example
# ./dockerrun.sh gen_images.py --outdir=out --trunc=1 --seeds=2 \
#         --network=https://api.ngc.nvidia.com/v2/models/nvidia/research/stylegan3/versions/1/files/stylegan3-r-afhqv2-512x512.pkl

# -----------------------------------
# MOD INFO
#  apt:  libglvnd0 libgl1 libglx0 libegl1 libgles2 libglvnd-dev libgl1-mesa-dev libegl1-mesa-dev libgles2-mesa-dev zlib1g-dev libjpeg-dev libwebp-dev
#  pip:  glfw imgui pyopengl
#  user and group envs


FROM nvcr.io/nvidia/pytorch:21.08-py3

SHELL ["/bin/bash", "-c"]

USER root
RUN apt-get -yqq update
RUN apt-get install -yq --no-install-recommends libglvnd0 libgl1 libglx0 libegl1 libgles2 libglvnd-dev \
    libgl1-mesa-dev libegl1-mesa-dev libgles2-mesa-dev zlib1g-dev libjpeg-dev libwebp-dev \
    && apt-get autoremove -y && apt-get clean -y

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --no-cache-dir imageio imageio-ffmpeg==0.4.4 pyspng==0.1.0 glfw imgui pyopengl

WORKDIR /workspace

RUN (printf '#!/bin/bash\nexec \"$@\"\n' >> /entry.sh) && chmod a+x /entry.sh
ENTRYPOINT ["/entry.sh"]