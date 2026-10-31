FROM ghcr.io/void-linux/void-glibc:latest

RUN xbps-install -Syu xbps && \
    xbps-install -y bash curl wget openssh fastfetch && \
    xbps-install -y ttyd && \
    xbps-remove -O

WORKDIR /root

CMD ["sh", "-c", "exec ttyd -p ${PORT:-10000} -t enable-paste=true -W bash -lc 'fastfetch; exec bash'"]