FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    xvfb x11vnc fluxbox novnc websockify xterm ttyd curl git python3 python3-pip net-tools wget \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
CMD ["/app/entrypoint.sh"]