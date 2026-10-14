#!/bin/bash

PORT=${PORT:-10000}

echo "=== KHỞI ĐỘNG HỆ THỐNG X11 + novnc ==="

if [ "$ENABLE_X11" = "true" ]; then
    echo "[+] Đang bật màn hình ảo X11..."
    
    # 1. Khởi tạo màn hình ảo
    Xvfb :99 -screen 0 1024x768x16 &
    export DISPLAY=:99
    sleep 1

    # 2. Chạy Openbox (Window Manager)
    openbox-session &

    # 3. Mở sẵn terminal mẫu
    xterm -geometry 80x24+10+10 &

    # 4. Chạy x11vnc stream ra cổng 5900
    x11vnc -display :99 -forever -shared -nopw -rfbport 5900 &
    sleep 1

    # 5. Dùng noVNC vừa tải để đẩy lên URL qua cổng của Render
    echo "[+] Đang mở cổng VNC Web trên port $PORT..."
    exec /opt/novnc/utils/novnc_proxy --vnc localhost:5900 --listen $PORT
else
    echo "[-] Chạy chế độ Web Shell (CMD dòng lệnh)..."
    exec ttyd -p $PORT -W bash
fi