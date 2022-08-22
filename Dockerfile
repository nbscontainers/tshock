FROM docker.io/alpine:3.16.2 AS downloader

ARG TERRARIA_VERSION=1.4.3.6
ARG TSHOCK_VERSION=4.5.18

RUN mkdir /tshock && \
    cd /tshock && \
    wget -q https://github.com/Pryaxis/TShock/releases/download/v${TSHOCK_VERSION}/TShock${TSHOCK_VERSION}_Terraria${TERRARIA_VERSION}.zip && \
    unzip TShock${TSHOCK_VERSION}_Terraria${TERRARIA_VERSION}.zip && \
    rm TShock${TSHOCK_VERSION}_Terraria${TERRARIA_VERSION}.zip

FROM docker.io/mono:6

COPY --from=downloader /tshock /tshock

WORKDIR /tshock

VOLUME [ "/tshock/tshock" ]

EXPOSE 7777

ENTRYPOINT [ "mono", "TerrariaServer.exe" ]

CMD [ "-port", "7777", "-worldpath", "/tshock/tshock/Worlds", "-worldselectpath", "/tshock/tshock/World", "-logpath", "/tmp" ]
