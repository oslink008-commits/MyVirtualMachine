FROM alpine:latest

ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt Xvfb, x11vnc, fluxbox và các công cụ cần thiết (bỏ qua novnc)
RUN apk update && apk add --no-cache \
    xvfb \
    x11vnc \
    fluxbox \
    bash \
    procps \
    net-tools \
    wget \
    ca-certificates

WORKDIR /app

# Viết script khởi động: Bật Xvfb, chạy Fluxbox và x11vnc bám thẳng vào cổng PORT của Render
RUN echo '#!/bin/bash' > /app/start.sh && \
    echo 'rm -f /tmp/.X99-lock' >> /app/start.sh && \
    echo 'Xvfb :99 -screen 0 1024x768x16 -ac +extension RANDR &' >> /app/start.sh && \
    echo 'export DISPLAY=:99' >> /app/start.sh && \
    echo 'sleep 2' >> /app/start.sh && \
    echo 'fluxbox &' >> /app/start.sh && \
    echo 'sleep 2' >> /app/start.sh && \
    echo 'exec x11vnc -display :99 -forever -shared -nopw -rfbport ${PORT:-10000}' >> /app/start.sh && \
    chmod +x /app/start.sh

CMD ["/app/start.sh"]