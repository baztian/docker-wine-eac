FROM baztian/wine

USER root
RUN usermod -aG cdrom wineuser
USER wineuser
RUN WINEARCH=win32 xvfb-run -a winetricks -q dotnet20 && wineserver --wait \
    && rm -rf ~/.cache/winetricks/*
RUN WINEARCH=win32 xvfb-run -a winetricks -q dotnet40 && wineserver --wait \
    && rm -rf ~/.cache/winetricks/*
ENV LAME_VERSION=3.100-20190722
ENV LAME_HASH=04196577fad783cff6c4b847b46a4ef9e3c5b728
RUN curl -L -o /tmp/lame.zip http://www.rarewares.org/files/mp3/lame${LAME_VERSION}.zip && \
    echo ${LAME_HASH} /tmp/lame.zip | (sha1sum -c && \
    unzip -u /tmp/lame.zip -d ${USER_PATH} lame.exe lame_enc.dll && rm /tmp/lame.zip)
ENV EAC_VERSION=1.5
ENV EAC_HASH=F4B9DA1ABC0ECFCD7466EC903BF87BBA51872B87
RUN curl -L -o /tmp/eac.exe http://www.exactaudiocopy.de/eac-${EAC_VERSION}.exe && \
    echo ${EAC_HASH} /tmp/eac.exe | ( sha1sum -c && \
    WINEARCH=win32 xvfb-run -a wine /tmp/eac.exe /S && rm /tmp/eac.exe && wineserver --wait && \
    rm -rf /tmp/.wine* /tmp/wine*)
RUN (cd /wine/drive_c/Program\ Files/Exact\ Audio\ Copy/ && regsvr32 sql*) || true ; \
     wineserver --wait && rm -rf /tmp/.wine* /tmp/wine*
# Doesn't work:
# docker exec -it wine-eac regedit /E - 'HKEY_CURRENT_USER\Software\AWSoftware\EACU' > eac.reg
# works:
# me@desktop ~/Sources/docker-wine-eac $ docker exec -it wine-eac /bin/bash
# wineuser@ba5a92e2a120:/$ regedit /E - 'HKEY_CURRENT_USER\Software\AWSoftware\EACU' > /tmp/eac.reg
# Or even better: export as REGEDIT4 file from regedit GUI and then copy via
# docker cp wine-eac:/tmp/eac.reg .
ADD eac-diff.reg ${USER_PATH}/
RUN regedit ${USER_PATH}/eac-diff.reg && wineserver --wait && rm -rf /tmp/.wine* /tmp/wine*
RUN mkdir /wine/userdata && mv /wine/user.reg /wine/userdata/ && ln -sf userdata/user.reg /wine/user.reg
ENTRYPOINT wine /wine/drive_c/Program\ Files/Exact\ Audio\ Copy/EAC.exe && wineserver --wait
