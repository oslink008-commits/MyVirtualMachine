FROM alpine:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apk update && apk add --no-cache \
    ttyd \
    bash \
    procps \
    net-tools \
    wget \
    ca-certificates \
    fastfetch \
    openssh-server

WORKDIR /app

RUN echo 'root:rootpass' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    ssh-keygen -A

RUN echo '#!/bin/bash' > /app/start.sh && \
    echo 'fastfetch' >> /app/start.sh && \
    echo '/usr/sbin/sshd' >> /app/start.sh && \
    echo 'exec ttyd -p ${PORT:-10000} -W bash' >> /app/start.sh && \
    chmod +x /app/start.sh

EXPOSE 10000 22

CMD ["/app/start.sh"]
