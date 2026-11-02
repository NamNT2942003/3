#!/bin/bash
# ==========================================================
# Script: extract-logs.sh
# Mục tiêu: Trích xuất chính xác 15 dòng log cuối kèm timestamps
#           của container rikkei-course-service
# ==========================================================

set -e

CONTAINER_NAME="rikkei-course-service"
LINE_COUNT=15

echo "=== TRÍCH XUẤT LOGS CỦA CONTAINER: $CONTAINER_NAME ==="

# 1. Kiểm tra container có đang chạy không
if ! docker ps -q -f name="^/${CONTAINER_NAME}$" | grep -q .; then
    echo "[!] Container '$CONTAINER_NAME' chưa chạy. Đang khởi chạy..."
    docker run -d -p 8081:80 --name "$CONTAINER_NAME" nginxdemos/hello
fi

# 2. Giả lập truy cập học viên (tạo đủ 15 request để log có dữ liệu thực tế)
echo "[+] Đang gửi request giả lập để sinh dữ liệu nhật ký..."
for i in {1..15}; do
    curl -s http://localhost:8081 > /dev/null || true
done
echo "[OK] Đã sinh xong log truy cập."
echo ""

# 3. Lệnh trích xuất chính xác 15 dòng cuối kèm timestamp
echo "=== KẾT QUẢ DOCKER LOGS (15 DÒNG CUỐI KÈM TIMESTAMPS) ==="
docker logs --tail "$LINE_COUNT" --timestamps "$CONTAINER_NAME"
echo "========================================================="
