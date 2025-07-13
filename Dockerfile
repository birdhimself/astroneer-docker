FROM --platform=linux/arm64 debian:trixie

RUN apt-get update
RUN apt-get install -y wget gpg
#
#RUN dpkg --add-architecture i386
#
RUN mkdir -pm755 /etc/apt/keyrings
#RUN wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
#
#RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources
#
RUN apt-get update
RUN apt-get install -y python3-pip python3-venv git gnutls-bin wget unzip

RUN git clone https://github.com/JoeJoeTV/AstroTuxLauncher.git /astrotux

RUN mkdir /proton
RUN wget -O - https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton10-9/GE-Proton10-9.tar.gz | tar -xz --strip-components=1 -C /proton

RUN wget -qO- "https://pi-apps-coders.github.io/box64-debs/KEY.gpg" | gpg --dearmor -o /etc/apt/keyrings/box64-archive-keyring.gpg
RUN echo "Types: deb\nURIs: https://Pi-Apps-Coders.github.io/box64-debs/debian\nSuites: ./\nSigned-By: /etc/apt/keyrings/box64-archive-keyring.gpg" \
    | tee /etc/apt/sources.list.d/box64.sources > /dev/null
RUN apt-get update
RUN apt-get install -y box64-generic-arm

RUN mkdir -p /astrotux/libs
RUN rm -f /astrotux/libs/depotdownloader
RUN wget -qO- https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_3.4.0/DepotDownloader-linux-arm64.zip | unzip -p - DepotDownloader > /astrotux/libs/depotdownloader
RUN chmod +x /astrotux/libs/depotdownloader

VOLUME /astrotux/AstroneerServer/Astro/Saved

EXPOSE 7777/udp

COPY --chmod=0755 ./install.sh /install.sh
COPY --chmod=0755 ./entrypoint.sh /entrypoint.sh
COPY --chmod=0644 ./launcher.toml /astrotux/launcher.toml

RUN /install.sh

ENV DISABLE_ENCRYPTION=false
ENV FORCE_CHOWN=false

ENTRYPOINT [ "/entrypoint.sh" ]
