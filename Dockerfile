FROM alpine:3.24

RUN apk update && apk add --no-cache \
    fastfetch \
    openssh \
    bash \
    curl \
    wget

RUN ssh-keygen -A

WORKDIR /root

CMD ["sh"]