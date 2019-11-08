# Docker Exact Audio Copy via wine

[Exact Audio Copy](http://www.exactaudiocopy.de/) via wine.

By default it writes data to `/Data`. Consider to mount this to a host directory.

## Buiding

    ./build.sh

## Usage

    docker run --rm -it --privileged -v ${HOME}/Music:/Data -v /tmp/.X11-unix/:/tmp/.X11-unix/ -v /dev/sg0:/dev/sg0 -v /dev/sg1:/dev/sg1 -e DISPLAY=${DISPLAY} --name wine-eac baztian/wine-eac

## Development

    git tag $(grep -oP 'EAC_VERSION=\K.+' Dockerfile)-$(git rev-parse --short HEAD)
    git push && git push --tags
