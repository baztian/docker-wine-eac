#!/bin/sh
set -e

docker build . -t baztian/wine-eac

echo now run:
echo 'docker run --rm -it --privileged -v /tmp/.X11-unix/:/tmp/.X11-unix/ -v /dev/sg0:/dev/sg0 -v /dev/sg1:/dev/sg1 -e DISPLAY=${DISPLAY} --name wine-eac baztian/wine-eac'
