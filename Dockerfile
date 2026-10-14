FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    bash \
    procps \
    net-tools \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Tải ttyd bản chuẩn trực tiếp từ GitHub
RUN curl -L https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 -o /usr/local/bin/ttyd && \
    chmod +x /usr/local/bin/ttyd

WORKDIR /app

# tty
CMD ["ttyd", "-p", "10000", "-W", "bash"]