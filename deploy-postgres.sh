#!/bin/bash
# ==========================================================
# Script: deploy-postgres.sh
# Mục tiêu: Triển khai Database PostgreSQL bền vững với Bind Mount Volume
# ==========================================================

set -e

CONTAINER_NAME="rikkei-db"
IMAGE_NAME="postgres:13"
HOST_DATA_DIR="/opt/rikkei/pg-data"
CONTAINER_DATA_DIR="/var/lib/postgresql/data"
DB_PASS="Rikkei@2026"

echo "=== TRIỂN KHAI POSTGRESQL VỚI PERSISTENT DATA ==="

# 1. Tạo thư mục dữ liệu trên host nếu chưa có
echo "[+] Đang chuẩn bị thư mục dữ liệu host: $HOST_DATA_DIR..."
sudo mkdir -p "$HOST_DATA_DIR"
echo "[OK] Thư mục đã sẵn sàng."

# 2. Xóa container cũ nếu đang chạy để làm sạch môi trường test
if [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "[!] Container '${CONTAINER_NAME}' cũ đang tồn tại. Tiến hành dọn dẹp..."
    docker rm -f "$CONTAINER_NAME"
fi

# 3. Khởi chạy container PostgreSQL
echo "[+] Đang khởi chạy container '${CONTAINER_NAME}'..."
docker run -d \
    --name "$CONTAINER_NAME" \
    -e POSTGRES_PASSWORD="$DB_PASS" \
    -v "${HOST_DATA_DIR}:${CONTAINER_DATA_DIR}" \
    "$IMAGE_NAME"

echo "[OK] Container '${CONTAINER_NAME}' đã khởi chạy."
echo "[+] Đang chờ PostgreSQL khởi tạo cấu trúc dữ liệu lần đầu (khoảng 8 giây)..."
sleep 8

# 4. Kiểm thử khả năng bền vững: Xóa container và tạo lại
echo ""
echo "=== KIỂM THỬ TÍNH BỀN VỮNG CỦA DỮ LIỆU ==="
echo "[+] Bước 1: Cưỡng chế xóa container '$CONTAINER_NAME' (docker rm -f)..."
docker rm -f "$CONTAINER_NAME"
echo "[OK] Đã xóa container."

echo "[+] Bước 2: Khởi chạy lại container '$CONTAINER_NAME' mới với cùng volume..."
docker run -d \
    --name "$CONTAINER_NAME" \
    -e POSTGRES_PASSWORD="$DB_PASS" \
    -v "${HOST_DATA_DIR}:${CONTAINER_DATA_DIR}" \
    "$IMAGE_NAME"
echo "[OK] Container mới đã khởi chạy thành công."

# 5. Kiểm tra danh sách file trên máy host
echo ""
echo "=== KẾT QUẢ KIỂM TRA DỮ LIỆU TRÊN HOST (ls -l $HOST_DATA_DIR) ==="
ls -l "$HOST_DATA_DIR"
echo "=================================================================="
