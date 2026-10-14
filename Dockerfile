FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Cập nhật và cài đặt các gói giao diện X11, openbox và novnc một cách gọn gàng
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

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]