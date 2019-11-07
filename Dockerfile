FROM baztian/wine

ADD target/eac.exe ${USER_PATH}/
ADD target/lame/ ${USER_PATH}/
RUN WINEARCH=win32 xvfb-run -a winetricks -q dotnet20 \
    && rm -rf ~/.cache/winetricks/*
RUN WINEARCH=win32 xvfb-run -a wine ${USER_PATH}/eac.exe /S
RUN (cd /wine/drive_c/Program\ Files/Exact\ Audio\ Copy/ && regsvr32 sql* || true)
RUN rm -rf /tmp/.wine*
# Doesn't work:
# docker exec -it wine-exact-audio-copy regedit /E - 'HKEY_CURRENT_USER\Software\AWSoftware\EACU' > eac.reg
# works:
# me@desktop ~/Sources/docker-wine-exact-audio-copy $ docker exec -it wine-exact-audio-copy /bin/bash
# wineuser@ba5a92e2a120:/$ regedit /E - 'HKEY_CURRENT_USER\Software\AWSoftware' > /tmp/eac.reg
# Or even better: export as REGEDIT4 file
# docker cp wine-exact-audio-copy:/tmp/eac.reg .
ADD eac.reg ${USER_PATH}/
RUN regedit ${USER_PATH}/eac.reg && wineserver --wait
ENTRYPOINT wine /wine/drive_c/Program\ Files/Exact\ Audio\ Copy/EAC.exe && wineserver --wait
