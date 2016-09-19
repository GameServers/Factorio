FROM ubuntu:14.04

MAINTAINER Jason Rivers <docker@jasonrivers.co.uk>

WORKDIR /opt

COPY ./new_smart_launch.sh /opt/

VOLUME /opt/factorio/saves /opt/factorio/mods

EXPOSE 34197/udp
EXPOSE 27015/tcp

CMD ["./new_smart_launch.sh"]

ENV FACTORIO_BUILD=stable \
    FACTORIO_AUTOSAVE_INTERVAL=2 \
    FACTORIO_AUTOSAVE_SLOTS=3 \
    FACTORIO_ALLOW_COMMANDS=false \
    FACTORIO_NO_AUTO_PAUSE=false \
    FACTORIO_WAITING=false \
    FACTORIO_MODE=normal \
    FACTORIO_SERVER_NAME="Factorio Server" \
    FACTORIO_SERVER_DESCRIPTION= \
    FACTORIO_SERVER_MAX_PLAYERS= \
    FACTORIO_SERVER_VISIBILITY=lan \
    FACTORIO_USER_USERNAME= \
    FACTORIO_USER_PASSWORD= \
    FACTORIO_SERVER_GAME_PASSWORD= \
    FACTORIO_SERVER_VERIFY_IDENTITY=false \
    FACTORIO_SERVER_VERSION=

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

## Pre-load the image with the stable version

RUN  wget -q -O - https://www.factorio.com/download-headless/${FACTORIO_BUILD} | grep -o -m1 "/get-download/.*/headless/linux64" | tee /tmp/factorioV | awk '{print "--no-check-certificate https://www.factorio.com"$1" -O /tmp/factorio.tar.gz"}' | xargs wget \
  && tar -xzf /tmp/factorio.tar.gz -C /opt \
  && rm -rf /tmp/factorio.tar.gz    \
  && cat /tmp/factorioV | sed 's/\/get-download\/\(.*\)\/headless\/linux64/\1/' >> /opt/factorio/currentVersion
