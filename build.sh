#!/bin/sh
set -e

docker build . -t baztian/wine-eac

echo now run:
echo 'docker run -v ${HOME}/Music:/Data --rm --privileged --cap-drop ALL --device /dev/sg0 --device /dev/sg1 -v /tmp/.X11-unix/:/tmp/.X11-unix/ -e DISPLAY=${DISPLAY} --name wine-eac baztian/wine-eac'
