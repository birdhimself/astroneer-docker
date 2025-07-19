FROM ghcr.io/birdhimself/base-proton:latest

RUN apt-get update
RUN apt-get install -y python3-pip python3-venv git gnutls-bin

RUN git clone https://github.com/birdhimself/AstroTuxLauncher.git /astrotux

COPY ./launcher.toml /astrotux/

VOLUME /astrotux/AstroneerServer/Astro/Saved

EXPOSE 7777/udp

COPY --chmod=0755 ./install.sh /install.sh
COPY --chmod=0755 ./entrypoint.sh /entrypoint.sh

RUN /install.sh

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

ENV DISABLE_ENCRYPTION=false
ENV FORCE_CHOWN=false
ENV DEBUG=false

ENTRYPOINT [ "/entrypoint.sh" ]
