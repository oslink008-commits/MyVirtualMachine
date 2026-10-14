FROM alpine:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apk update && apk add --no-cache \
    curl \
    bash \
    procps \
    net-tools \
    wget \
    ca-certificates

RUN curl -L https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 -o /usr/local/bin/ttyd && \
    chmod +x /usr/local/bin/ttyd

WORKDIR /dev/shm

CMD sh -c "ttyd -p ${PORT:-10000} -W bash"