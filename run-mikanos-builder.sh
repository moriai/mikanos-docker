#!/usr/bin/env bash

: ${XUID:=1000}
: ${WAYLAND_SOCK:=/run/user/$XUID/wayland-0}
: ${X11_DIR:=/tmp/.X11-unix}
: ${IMAGE:=mikanos-builder:latest}

if [ -S "$WAYLAND_SOCK" ]; then
    docker run --privileged -it "$@" \
        --user $XUID:$XUID \
        -v "$WAYLAND_SOCK":"$WAYLAND_SOCK":rw \
        -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
        -e WAYLAND_DISPLAY=wayland-0 \
        $IMAGE /bin/bash
elif [ -d "$X11_DIR" ]; then
    docker run --privileged -it "$@" \
        --user $XUID:$XUID \
        --mount type=bind,source="$X11_DIR",target="$X11_DIR" \
        -v /run/user/$XUID/at-spi/bus_1:/run/user/$XUID/at-spi/bus_1:rw \
        -e XDG_SESSION_TYPE=$XDG_SESSION_TYPE \
        -e DISPLAY=$DISPLAY \
        $IMAGE /bin/bash
else
    docker run --privileged -it "$@" \
        --user $XUID:$XUID \
        $IMAGE /bin/bash
fi
