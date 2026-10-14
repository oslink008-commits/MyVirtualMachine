FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt thêm procps (chứa lệnh ps cho novnc) và các công cụ giao diện
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    x11vnc \
    openbox \
    novnc \
    websockify \
    procps \
    python3 \
    net-tools \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Viết lại script khởi chạy thông minh: tự dọn dẹp khóa cũ và chạy chuẩn xác
RUN echo '#!/bin/bash' > /app/start.sh && \
    echo 'rm -rf /tmp/.X*-lock /tmp/.X11-unix/*' >> /app/start.sh && \
    echo 'Xvfb :99 -screen 0 1024x768x16 &' >> /app/start.sh && \
    echo 'export DISPLAY=:99' >> /app/start.sh && \
    echo 'sleep 1' >> /app/start.sh && \
    echo 'openbox-session &' >> /app/start.sh && \
    echo 'x11vnc -display :99 -forever -shared -nopw -rfbport 5900 &' >> /app/start.sh && \
    echo 'sleep 1' >> /app/start.sh && \
    echo 'exec /usr/share/novnc/utils/novnc_proxy --vnc localhost:5900 --listen ${PORT:-10000}' >> /app/start.sh && \
    chmod +x /app/start.sh

CMD ["/app/start.sh"]