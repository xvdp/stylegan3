# Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

# @xvdp add
#   glfw imgui pyopengl

# @xvdp comments
# $ docker run --gpus all -it --rm --user $(id -u):$(id -g) -v `pwd`:/scratch --workdir /scratch -e HOME=/scratch --entrypoint /bin/bash stylegan3

# cannot run python visualizer.py without doing X11 forwarding !
# $ docker run --gpus all -it --rm --user $(id -u):$(id -g) -v `pwd`:/scratch --workdir /scratch -e HOME=/scratch stylegan3 python visualizer.py

# /opt/conda/lib/python3.8/site-packages/glfw/__init__.py:916: GLFWError: (65544) b'X11: The DISPLAY environment variable is missing'
#   warnings.warn(message, GLFWError)
# /opt/conda/lib/python3.8/site-packages/glfw/__init__.py:916: GLFWError: (65537) b'The GLFW library is not initialized'
#   warnings.warn(message, GLFWError)
# python: /builds/florianrhiem/pyGLFW/glfw-3.3.8/src/input.c:855: glfwSetKeyCallback: Assertion `window != ((void *)0)' failed.


FROM nvcr.io/nvidia/pytorch:21.08-py3


SHELL ["/bin/bash", "-c"]

USER root
RUN apt-get -yqq update
RUN apt-get install -yq --no-install-recommends libglvnd0 libgl1 libglx0 libegl1 libgles2 libglvnd-dev
RUN apt-get install -yq --no-install-recommends libgl1-mesa-dev libegl1-mesa-dev libgles2-mesa-dev
RUN apt-get install -yq --no-install-recommends zlib1g-dev libjpeg-dev libwebp-dev
RUN apt-get autoremove -y && apt-get clean -y


ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1


RUN pip install --no-cache-dir imageio imageio-ffmpeg==0.4.4 pyspng==0.1.0 glfw imgui pyopengl

WORKDIR /workspace

RUN (printf '#!/bin/bash\nexec \"$@\"\n' >> /entry.sh) && chmod a+x /entry.sh
ENTRYPOINT ["/entry.sh"]
