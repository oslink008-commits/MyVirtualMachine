FROM alpine:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apk update && apk add --no-cache \
    ttyd \
    bash \
    procps \
    net-tools \
    wget \
    ca-certificates \
    fastfetch

WORKDIR /app

RUN echo '#!/bin/bash' > /app/start.sh && \
    echo 'fastfetch' >> /app/start.sh && \
    echo 'exec ttyd -p ${PORT:-10000} -W bash' >> /app/start.sh && \
    chmod +x /app/start.sh

CMD ["/app/start.sh"]