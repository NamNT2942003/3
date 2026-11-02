#!/bin/bash
# ==========================================================
# Script: exec-frontend.sh
# Mục tiêu: Khởi chạy container với biến môi trường API_ENDPOINT
#           và kiểm tra giá trị qua docker exec
# ==========================================================

set -e

CONTAINER_NAME="rikkei-frontend-qa"
IMAGE_NAME="nginx"
ENV_KEY="API_ENDPOINT"
ENV_VALUE="https://qa-api.rikkei.edu.vn"

echo "=== CẤU HÌNH MÔI TRƯỜNG CHO FRONTEND QA ==="

# 1. Dọn dẹp container cũ nếu đã tồn tại
if [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "[!] Container '${CONTAINER_NAME}' đã tồn tại. Đang dọn dẹp để khởi tạo mới..."
    docker rm -f "$CONTAINER_NAME"
fi

# 2. Khởi chạy container với biến môi trường
echo "[+] Đang khởi chạy container '${CONTAINER_NAME}' từ image '${IMAGE_NAME}'..."
echo "[+] Gán biến môi trường: ${ENV_KEY}=${ENV_VALUE}"
docker run -d \
    --name "$CONTAINER_NAME" \
    -e "${ENV_KEY}=${ENV_VALUE}" \
    "$IMAGE_NAME"

echo "[OK] Container '${CONTAINER_NAME}' đã khởi chạy thành công."
echo ""

# 3. Thực thi kiểm tra biến môi trường bên trong container bằng docker exec
echo "=== KIỂM TRA BIẾN MÔI TRƯỜNG BÊN TRONG CONTAINER QUA DOCKER EXEC ==="
echo "$ docker exec $CONTAINER_NAME bash -c 'echo \$$ENV_KEY'"
docker exec "$CONTAINER_NAME" bash -c "echo \$$ENV_KEY"
echo "==================================================================="
echo ""
echo "[Gợi ý] Để vào shell tương tác trực tiếp, chạy lệnh:"
echo "docker exec -it $CONTAINER_NAME bash"
