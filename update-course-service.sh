#!/bin/bash
# ==========================================================
# Script: update-course-service.sh
# Mục tiêu: Tự động hóa cập nhật Course-Service (Mini CI/CD)
# Ràng buộc: Chạy dưới quyền user rikkeilms
# ==========================================================

LOG_FILE="/opt/rikkei/deploy.log"
CONTAINER_NAME="rikkei-course-service"
IMAGE_NAME="nginxdemos/hello"
PORT_MAPPING="8081:80"

# Hàm ghi log kèm mốc thời gian, xuất đồng thời ra console và file log
log_message() {
    local MSG="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    echo "$MSG" | tee -a "$LOG_FILE"
}

log_message "=========================================================="
log_message "BẮT ĐẦU QUY TRÌNH DEPLOY COURSE-SERVICE (User: $(whoami))"
log_message "=========================================================="

# 1. Kiểm tra container cũ
log_message "Đang kiểm tra container '$CONTAINER_NAME'..."
EXISTING_CONTAINER=$(docker ps -aq -f name="^/${CONTAINER_NAME}$")

if [ -n "$EXISTING_CONTAINER" ]; then
    log_message "Phát hiện container '$CONTAINER_NAME' đang tồn tại (ID: $EXISTING_CONTAINER)."
    
    # Kiểm tra xem container có đang chạy không để stop
    if [ "$(docker ps -q -f name="^/${CONTAINER_NAME}$")" ]; then
        log_message "Đang dừng (stop) container '$CONTAINER_NAME'..."
        docker stop "$CONTAINER_NAME" >> "$LOG_FILE" 2>&1
        log_message "Đã dừng container thành công."
    fi
    
    log_message "Đang xóa (rm) container '$CONTAINER_NAME'..."
    docker rm "$CONTAINER_NAME" >> "$LOG_FILE" 2>&1
    log_message "Đã xóa container thành công."
else
    log_message "Container '$CONTAINER_NAME' chưa tồn tại. Tiếp tục bước tạo mới."
fi

# 2. Khởi chạy container mới
log_message "Đang khởi chạy container mới '$CONTAINER_NAME' trên cổng $PORT_MAPPING..."
docker run -d \
    -p "$PORT_MAPPING" \
    --name "$CONTAINER_NAME" \
    "$IMAGE_NAME" >> "$LOG_FILE" 2>&1

log_message "Container '$CONTAINER_NAME' đã được khởi chạy thành công."

# 3. Kiểm tra trạng thái dịch vụ
if [ "$(docker ps -q -f name="^/${CONTAINER_NAME}$")" ]; then
    log_message "Trạng thái: Hoạt động bình thường (Healthy/Running)."
else
    log_message "[LỖI] Khởi động container thất bại!"
    exit 1
fi

log_message "HOÀN TẤT TRIỂN KHAI THÀNH CÔNG."
log_message "=========================================================="
echo ""
