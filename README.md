# Rikkei LMS - DevOps Practice: Linux & Docker

Dự án thực hành quản trị hệ thống Linux và vận hành Docker Containers cho hệ thống Rikkei LMS.

## Danh sách bài thực hành và sản phẩm bàn giao

| STT | Tên bài thực hành | Kịch bản triển khai | Bằng chứng kiểm thử |
| :---: | :--- | :--- | :--- |
| **1** | Thiết lập quyền và không gian làm việc | `setup-workspace.sh` | `evidence_01.png` |
| **2** | Khởi chạy Course-Service phiên bản Mock | `run-course-service.sh` | `evidence_02.png` |
| **3** | Giám sát truy cập học viên qua Docker Logs | `extract-logs.sh` | `evidence_03.png` |
| **4** | Cấu hình Môi trường cho Frontend QA | `exec-frontend.sh` | `evidence_04.png` |
| **5** | Triển khai Database PostgreSQL bền vững | `deploy-postgres.sh` | `evidence_05.png` |
| **6** | Tự động hóa cập nhật Course-Service (Mini CI/CD) | `update-course-service.sh` | `evidence_06.png` |

---

## Chi tiết từng bài thực hành

### Bài 1: Thiết lập quyền và không gian làm việc cho Rikkei LMS
- **Mục tiêu:** Tạo user cô lập `rikkeilms`, tạo không gian làm việc `/opt/rikkei/course-service`, phân quyền `755` (`drwxr-xr-x`).
- **Thực thi:**
  ```bash
  bash setup-workspace.sh
  ```
- **Kiểm tra:**
  ```bash
  ls -ld /opt/rikkei/course-service
  ```

### Bài 2: Khởi chạy Course-Service phiên bản Mock
- **Mục tiêu:** Khởi chạy container `nginxdemos/hello` ở chế độ detached, định danh `rikkei-course-service`, ánh xạ cổng `8081:80`.
- **Thực thi:**
  ```bash
  bash run-course-service.sh
  ```
- **Kiểm tra:**
  ```bash
  docker ps
  curl -i http://localhost:8081
  ```

### Bài 3: Giám sát truy cập học viên qua Docker Logs
- **Mục tiêu:** Trích xuất chính xác 15 dòng log gần nhất của container `rikkei-course-service` kèm timestamps.
- **Thực thi:**
  ```bash
  bash extract-logs.sh
  ```
- **Lệnh cốt lõi:**
  ```bash
  docker logs --tail 15 --timestamps rikkei-course-service
  ```

### Bài 4: Cấu hình Môi trường cho Frontend QA
- **Mục tiêu:** Khởi chạy container `rikkei-frontend-qa` từ image `nginx`, cấu hình biến môi trường `API_ENDPOINT=https://qa-api.rikkei.edu.vn`, xác minh qua `docker exec`.
- **Thực thi:**
  ```bash
  bash exec-frontend.sh
  ```
- **Lệnh xác minh:**
  ```bash
  docker exec -it rikkei-frontend-qa bash -c 'echo $API_ENDPOINT'
  ```

### Bài 5: Triển khai Database PostgreSQL bền vững
- **Mục tiêu:** Khởi chạy `rikkei-db` (`postgres:13`) với mật khẩu `Rikkei@2026`, cấu hình Bind Mount Volume `/opt/rikkei/pg-data:/var/lib/postgresql/data`. Xác minh tính bền vững khi xóa container (`docker rm -f`) và khởi chạy lại.
- **Thực thi:**
  ```bash
  bash deploy-postgres.sh
  ```
- **Kiểm tra:**
  ```bash
  ls -l /opt/rikkei/pg-data
  ```

### Bài 6: Tự động hóa cập nhật Course-Service (Mini CI/CD)
- **Mục tiêu:** Tự động hóa quy trình dọn dẹp container cũ và triển khai bản mới không bị gián đoạn hay lỗi xung đột cổng. Ghi nối toàn bộ log vào `/opt/rikkei/deploy.log`. Chạy dưới quyền user `rikkeilms`.
- **Thực thi:**
  ```bash
  bash update-course-service.sh
  ```
- **Kiểm tra:**
  ```bash
  cat /opt/rikkei/deploy.log
  ```
