#!/bin/sh
set -e

get()
{
    if ! [ -f $1 ]; then
        curl -L -o $1 "$2"
        echo $3 $1 | sha1sum -c || (sha1sum $1 && rm $1 && exit 1)
    fi
}
mkdir -p target
#get target/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks f63ad42c13165f5faae7a9c6897d8a6aa615325b
#get target/eac.exe http://www.exactaudiocopy.de/eac-1.3.exe 49f1028bd2b0cce0829250430bf8771c4a766daf
get target/eac.exe http://www.exactaudiocopy.de/eac-1.1.exe aa8ef57bb3bf0be7c00a32272c1b4ab7579934ec
# TODO: Copy zipped file and unzip in docker?
get target/lame.zip http://www.rarewares.org/files/mp3/lame3.100-20190806.zip 4f77f9b1186674bf92c0f69b5923e94a38f88058
unzip -u target/lame.zip -d target/lame lame.exe lame_enc.dll

docker build . -t baztian/wine-exact-audio-copy

echo now run:
echo 'docker run --rm -it --privileged -v /tmp/.X11-unix/:/tmp/.X11-unix/ -v /dev/sg0:/dev/sg0 --v /dev/sg1:/dev/sg1 -e DISPLAY=${DISPLAY} --name wine-exact-audio-copy baztian/wine-exact-audio-copy'
