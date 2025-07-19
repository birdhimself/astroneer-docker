FROM debian:trixie

RUN apt-get update
RUN apt-get install -y wget gpg

RUN dpkg --add-architecture i386

RUN mkdir -pm755 /etc/apt/keyrings
RUN wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -

RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources

RUN apt-get update
RUN apt-get install -y winehq-devel python3-pip python3-venv git gnutls-bin
RUN git clone https://github.com/birdhimself/AstroTuxLauncher.git /astrotux


VOLUME /astrotux/AstroneerServer/Astro/Saved

EXPOSE 7777/udp

COPY --chmod=0755 ./install.sh /install.sh
COPY --chmod=0755 ./entrypoint.sh /entrypoint.sh

RUN /install.sh

ENV DISABLE_ENCRYPTION=false
ENV FORCE_CHOWN=false

ENTRYPOINT [ "/entrypoint.sh" ]
