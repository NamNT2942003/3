#!/bin/bash
# ==========================================================
# Script: setup-workspace.sh
# Mục tiêu: Thiết lập quyền và không gian làm việc cho Rikkei LMS
# ==========================================================

set -e

TARGET_DIR="/opt/rikkei/course-service"
TARGET_USER="rikkeilms"

echo "=== BẮT ĐẦU THIẾT LẬP WORKSPACE CHO RIKKEI LMS ==="

# 1. Tạo user rikkeilms nếu chưa tồn tại
if id "$TARGET_USER" &>/dev/null; then
    echo "[!] User '$TARGET_USER' đã tồn tại."
else
    echo "[+] Đang tạo user '$TARGET_USER'..."
    sudo useradd -m -s /bin/bash "$TARGET_USER"
    echo "[OK] Đã tạo user '$TARGET_USER' thành công."
fi

# Thêm user vào group docker để hỗ trợ chạy kịch bản tự động
sudo usermod -aG docker "$TARGET_USER" 2>/dev/null || true

# 2. Tạo thư mục /opt/rikkei/course-service
echo "[+] Đang tạo thư mục: $TARGET_DIR..."
sudo mkdir -p "$TARGET_DIR"
echo "[OK] Đã tạo thư mục thành công."

# 3. Chuyển quyền sở hữu cho rikkeilms:rikkeilms
echo "[+] Đang chuyển quyền sở hữu sang '$TARGET_USER:$TARGET_USER'..."
sudo chown -R "$TARGET_USER:$TARGET_USER" /opt/rikkei
echo "[OK] Đã gán quyền sở hữu thành công."

# 4. Cấp quyền truy cập 755 (drwxr-xr-x)
echo "[+] Đang thiết lập quyền 755 cho $TARGET_DIR..."
sudo chmod 755 "$TARGET_DIR"
echo "[OK] Đã phân quyền thành công."

# 5. Kiểm thử và hiển thị kết quả
echo ""
echo "=== KẾT QUẢ KIỂM TRA (ls -ld $TARGET_DIR) ==="
ls -ld "$TARGET_DIR"
echo "============================================="
