#!/bin/bash

docker run -it --rm -e XMODIFIERS -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v `pwd`:/home/pochi/ jnishii/ubuntu-anaconda3-opencv3
