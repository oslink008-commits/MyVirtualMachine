FROM alpine:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apk update && apk add --no-cache \
    xvfb \
    x11vnc \
    fluxbox \
    novnc \
    websockify \
    python3 \
    bash \
    procps \
    net-tools \
    wget \
    ca-certificates

WORKDIR /app

RUN echo '#!/bin/bash' > /app/start.sh && \
    echo 'rm -f /tmp/.X99-lock' >> /app/start.sh && \
    echo 'Xvfb :99 -screen 0 1024x768x16 -ac +extension RANDR &' >> /app/start.sh && \
    echo 'export DISPLAY=:99' >> /app/start.sh && \
    echo 'sleep 2' >> /app/start.sh && \
    echo 'fluxbox &' >> /app/start.sh && \
    echo 'sleep 2' >> /app/start.sh && \
    echo 'x11vnc -display :99 -forever -shared -nopw -rfbport 5900 -bg' >> /app/start.sh && \
    echo 'sleep 1' >> /app/start.sh && \
    echo 'exec websockify --web=/usr/share/novnc ${PORT:-10000} localhost:5900' >> /app/start.sh && \
    chmod +x /app/start.sh

CMD ["/app/start.sh"]