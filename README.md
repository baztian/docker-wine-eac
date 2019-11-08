# Docker Exact Audio Copy via wine

[Exact Audio Copy](http://www.exactaudiocopy.de/) via wine.

By default it writes data to `/Data`. Consider to mount this to a host directory.

## Buiding

    ./build.sh

## Usage

    docker run -v ${HOME}/Music:/Data --rm --privileged --cap-drop ALL --device /dev/sg0 --device /dev/sg1 -v /tmp/.X11-unix/:/tmp/.X11-unix/ -e DISPLAY=${DISPLAY} --name wine-eac baztian/wine-eac

To be able to persist settings mount a local volume for wine's `user.reg`.

    mkdir ~/.config/exact-audio-copy
    docker run -it --rm --entrypoint /bin/bash baztian/wine-eac -c 'cat /wine/userdata/user.reg' > ~/.config/exact-audio-copy/user.reg
    docker run -v ~/.config/exact-audio-copy/:/wine/userdata/ -v ${HOME}/Music:/Data --rm --privileged --cap-drop ALL --device /dev/sg0 --device /dev/sg1 -v /tmp/.X11-unix/:/tmp/.X11-unix/ -e DISPLAY=${DISPLAY} --name wine-eac baztian/wine-eac

## Development

    git tag $(grep -oP 'EAC_VERSION=\K.+' Dockerfile)-$(git rev-parse --short HEAD)
    git push && git push --tags
