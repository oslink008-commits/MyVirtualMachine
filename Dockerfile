FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt Xvfb, x11vnc, openbox, ttyd, git, python3 và các công cụ cần thiết
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    openbox \
    ttyd \
    git \
    python3 \
    net-tools \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Tải trực tiếp noVNC chính hãng từ GitHub về để chắc chắn có đủ giao diện web
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
    && ln -s /opt/novnc/vnc.html /opt/novnc/index.html

WORKDIR /app

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]