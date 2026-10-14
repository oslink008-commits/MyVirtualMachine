FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    x11vnc \
    openbox \
    novnc \
    websockify \
    python3 \
    net-tools \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Tự động tạo trực tiếp script khởi chạy chuẩn Linux ngay trong Dockerfile, không cần file .sh ngoài nữa
RUN echo '#!/bin/bash' > /app/start.sh && \
    echo 'Xvfb :99 -screen 0 1024x768x16 &' >> /app/start.sh && \
    echo 'export DISPLAY=:99' >> /app/start.sh && \
    echo 'sleep 1' >> /app/start.sh && \
    echo 'openbox-session &' >> /app/start.sh && \
    echo 'x11vnc -display :99 -forever -shared -nopw -rfbport 5900 &' >> /app/start.sh && \
    echo 'sleep 1' >> /app/start.sh && \
    echo 'exec /usr/share/novnc/utils/novnc_proxy --vnc localhost:5900 --listen ${PORT:-10000}' >> /app/start.sh && \
    chmod +x /app/start.sh

CMD ["/app/start.sh"]