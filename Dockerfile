
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt Xvfb, x11vnc, fluxbox (thay openbox để ổn định hơn), novnc và procps
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    x11vnc \
    fluxbox \
    novnc \
    websockify \
    procps \
    xterm \
    python3 \
    net-tools \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Viết script khởi động: Tắt X cũ, bật Xvfb, chạy fluxbox và x11vnc đúng thứ tự
RUN echo '#!/bin/bash' > /app/start.sh && \
    echo 'rm -f /tmp/.X99-lock' >> /app/start.sh && \
    echo 'Xvfb :99 -screen 0 1024x768x16 -ac +extension RANDR &' >> /app/start.sh && \
    echo 'export DISPLAY=:99' >> /app/start.sh && \
    echo 'sleep 2' >> /app/start.sh && \
    echo 'fluxbox &' >> /app/start.sh && \
    echo 'sleep 2' >> /app/start.sh && \
    echo 'x11vnc -display :99 -forever -shared -nopw -rfbport 5900 &' >> /app/start.sh && \
    echo 'sleep 1' >> /app/start.sh && \
    echo 'exec /usr/share/novnc/utils/novnc_proxy --vnc localhost:5900 --listen ${PORT:-10000}' >> /app/start.sh && \
    chmod +x /app/start.sh

CMD ["/app/start.sh"]