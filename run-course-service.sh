#!/bin/bash
# ==========================================================
# Script: run-course-service.sh
# Mục tiêu: Khởi chạy Course-Service phiên bản Mock (Nginx)
# ==========================================================

set -e

CONTAINER_NAME="rikkei-course-service"
IMAGE_NAME="nginxdemos/hello"
HOST_PORT="8081"
CONTAINER_PORT="80"

echo "=== KHỞI CHẠY COURSE-SERVICE MOCK (DOCKER) ==="

# 1. Kiểm tra và dọn dẹp container trùng tên nếu đã tồn tại
if [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "[!] Phát hiện container '${CONTAINER_NAME}' cũ. Đang dọn dẹp..."
    docker rm -f "$CONTAINER_NAME"
fi

# 2. Khởi chạy container mới
echo "[+] Đang chạy container '${CONTAINER_NAME}' trên cổng ${HOST_PORT}:${CONTAINER_PORT}..."
docker run -d \
    -p "${HOST_PORT}:${CONTAINER_PORT}" \
    --name "$CONTAINER_NAME" \
    "$IMAGE_NAME"

echo "[OK] Container đã khởi chạy thành công."
echo ""

# 3. Kiểm tra trạng thái container
echo "=== KIỂM TRA DOCKER PS ==="
docker ps -f name="^/${CONTAINER_NAME}$"
echo ""

# 4. Kiểm tra phản hồi HTTP qua curl
echo "=== KIỂM TRA PHẢN HỒI HTTP (curl http://localhost:${HOST_PORT}) ==="
curl -i -s "http://localhost:${HOST_PORT}" | head -n 25
echo ""
echo "=== HOÀN TẤT KIỂM THỬ ==="
