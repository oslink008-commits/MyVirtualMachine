FROM alpine:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apk update && apk add --no-cache \
    xvfb \
    x11vnc \
    fluxbox \
    novnc \
    websockify \
    ttyd \
    python3 \
    bash \
    procps \
    net-tools \
    wget \
    ca-certificates \
    fastfetch

WORKDIR /app

# Tạo trang chủ index.html có nút chuyển đổi giữa VNC và Terminal
RUN echo '<!DOCTYPE html><html><head><title>Render VM Workspace</title><style>body{margin:0;background:#1e1e1e;color:#fff;font-family:sans-serif;display:flex;flex-direction:column;height:100vh;}header{background:#2d2d2d;padding:10px;display:flex;gap:10px;align-items:center;}button{padding:8px 16px;background:#007acc;color:#white;border:none;cursor:pointer;border-radius:4px;}button:hover{background:#005999;}iframe{flex:1;border:none;width:100%;height:100%;}</style></head><body><header><h3>Render VM</h3><button onclick="loadVNC()">Màn hình VNC</button><button onclick="loadTerm()">Web Terminal (ttyd)</button></header><iframe id="viewport" src="vnc_lite.html"></iframe><script>function loadVNC(){document.getElementById("viewport").src="vnc_lite.html";}function loadTerm(){document.getElementById("viewport").src="http://"+window.location.host+"/term/";}</script></body></html>' > /usr/share/novnc/index.html

RUN echo '#!/bin/bash' > /app/start.sh && \
    echo 'rm -rf /tmp/.X*-lock /tmp/.X11-unix' >> /app/start.sh && \
    echo 'Xvfb :99 -screen 0 1024x768x16 -ac +extension RANDR &' >> /app/start.sh && \
    echo 'export DISPLAY=:99' >> /app/start.sh && \
    echo 'sleep 3' >> /app/start.sh && \
    echo 'fluxbox &' >> /app/start.sh && \
    echo 'sleep 2' >> /app/start.sh && \
    echo 'x11vnc -display :99 -forever -shared -nopw -rfbport 5900 -bg -noxdamage &' >> /app/start.sh && \
    echo 'sleep 2' >> /app/start.sh && \
    echo 'ttyd -p 7681 -W bash &' >> /app/start.sh && \
    echo 'exec websockify --web=/usr/share/novnc ${PORT:-10000} localhost:5900' >> /app/start.sh && \
    chmod +x /app/start.sh

CMD ["/app/start.sh"]