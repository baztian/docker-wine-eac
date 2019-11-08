# Docker Exact Audio Copy via wine

## Buiding

    ./build.sh

## Usage

    docker run --rm -it --privileged -v /tmp/.X11-unix/:/tmp/.X11-unix/ -v /dev/sg0:/dev/sg0 --v /dev/sg1:/dev/sg1 -e DISPLAY=${DISPLAY} --name wine-eac baztian/wine-eac

## Development

    git tag $(grep -oP '^EAC_VERSION=\K.+' hooks/pre_build)-$(git rev-parse --short HEAD)
    git push && git push --tags
