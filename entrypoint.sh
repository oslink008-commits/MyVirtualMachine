#!/bin/bash
PORT=${PORT:-10000}
echo "=== ĐANG KHỞI ĐỘNG HỆ THỐNG MÁY ẢO BẰNG RENDER ==="
if [ "$ENABLE_X11" = "true" ]; then
    Xvfb :99 -screen 0 1280x720x16 &
    export DISPLAY=:99
    sleep 1
    fluxbox &
    xterm -geometry 80x24+10+10 &
    x11vnc -display :99 -forever -shared -nopw -rfbport 5900 &
    sleep 1
    exec /usr/share/novnc/utils/novnc_proxy --vnc localhost:5900 --listen $PORT
else
    exec ttyd -p $PORT -W bash
fi