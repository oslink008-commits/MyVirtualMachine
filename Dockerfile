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

COPY entrypoint.sh /app/entrypoint.sh

# Thêm dòng này để tự động xóa lỗi định dạng Windows (CRLF -> LF)
RUN sed -i 's/\r$//' /app/entrypoint.sh && chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]