
FROM alpine:3.24

RUN apk add --no-cache \
    fastfetch \
    openssh \
    bash \
    curl \
    wget \
    ttyd

WORKDIR /root

RUN ssh-keygen -A

EXPOSE 10000

CMD ["sh", "-c", "exec ttyd -p ${PORT:-10000} -c \"${WEB_USER}:${WEB_PASSWORD}\" -W bash -c 'fastfetch; exec bash'"]
