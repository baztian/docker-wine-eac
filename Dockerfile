FROM baztian/wine

USER root
RUN usermod -aG cdrom wineuser
USER wineuser
RUN WINEARCH=win32 xvfb-run -a winetricks -q dotnet20 \
    && rm -rf ~/.cache/winetricks/*
ENV LAME_VERSION=3.100-20190806
ENV LAME_HASH=4f77f9b1186674bf92c0f69b5923e94a38f88058
RUN curl -L -o /tmp/lame.zip http://www.rarewares.org/files/mp3/lame${LAME_VERSION}.zip && \
    echo ${LAME_HASH} /tmp/lame.zip | (sha1sum -c && \
    unzip -u /tmp/lame.zip -d ${USER_PATH} lame.exe lame_enc.dll && rm /tmp/lame.zip)
ENV EAC_VERSION=1.3
ENV EAC_HASH=49f1028bd2b0cce0829250430bf8771c4a766daf
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
