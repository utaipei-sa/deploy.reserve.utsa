# deploy.reserve.utsa

## 目錄與文件說明

### `docker/`

- **`docker-compose-api.yaml`**：API 服務的 Docker Compose 配置文件。
- **`docker-compose-db.yaml`**：數據庫服務的 Docker Compose 配置文件。
- **`docker-compose-nginx.yaml`**：Nginx 服務的 Docker Compose 配置文件。
- **`docker-compose-ui.yaml`**：前端服務的 Docker Compose 配置文件。

### `mongodb/`

- **`configdb/`**：MongoDB 配置數據庫文件夾。
- **`data/`**：MongoDB 數據文件夾，存放 MongoDB 實例的數據。
- **`mongod.conf`**：MongoDB 配置文件，用於配置 MongoDB 實例的行為。

### `nginx/`

- **`nginx.conf`**：Nginx 配置文件，用於設置反向代理和負載均衡等功能。

### `scripts/`

- **`cicd.sh`**：CI/CD 腳本，用於自動化部署和更新 Docker 服務。

## CI/CD 腳本 (`cicd.sh`) 說明

### 腳本命令詳解

- **`CMD` 參數**：定義要執行的操作，如 `SERVICE_UP` 或 `UPDATE_IMAGE`。
  
  - **`SERVICE_UP`**：
    - 啟動後端和前端服務，同時帶上各自的版本號。
    - 啟動時依次調用 `docker-compose-db.yaml`、`docker-compose-api.yaml`、`docker-compose-ui.yaml`、`docker-compose-nginx.yaml`。
  
  - **`UPDATE_IMAGE`**：
    - 更新後端和前端服務的鏡像，並重啟 Nginx 服務。
    - 刪除舊的 Docker 鏡像以釋放空間。

- **`DOCKER_COMPOSE_NAMESPACE`**：設置 Docker Compose 的項目名稱空間，避免不同服務之間的沖突。

## 使用指南

### 1. **設置環境變量**：
   - 在開始使用之前，覆制 `.env.sample` 文件為 `.env`，並根據項目的實際需求填入對應的配置。

   ```bash
   cp .env.sample .env
   # 然後編輯 .env 文件並填入相關環境變量
   ```

### 2. **初始化服務**：
   - 執行以下命令來啟動所有服務。你需要指定後端和前端的版本號：

   ```bash
   ./scripts/cicd.sh SERVICE_UP <backend_version> <frontend_version>
   ```

   範例

   ```bash
   ./scripts/cicd.sh SERVICE_UP 1.0.0 1.0.0-test
   ```

### 3. **更新鏡像**：
   - 當需要更新服務鏡像並重啟 Nginx 時，執行以下命令並指定新的後端和前端版本號：

   ```bash
   ./scripts/cicd.sh UPDATE_IMAGE <backend_version> <frontend_version>
   ```

   範例

   ```bash
   ./scripts/cicd.sh UPDATE_IMAGE 1.1.0 1.1.0-test
   ```

### 4. **GitHub Container Registry（GHCR）授權**

要從 GHCR 拉取鏡像，你需要配置 Personal Access Token (PAT)。你可以通過以下步驟生成並配置 PAT：

- 前往 GitHub 並導航到 Settings > Developer settings > Personal access tokens。
- 生成一個新的 PAT，並勾選 `write:packages` 和 `read:packages` 權限。
- 在你本地的環境中，運行以下命令登錄 GHCR：

    ```bash
    echo <YOUR_PAT> | docker login ghcr.io -u <YOUR_GITHUB_USERNAME> --password-stdin
    ```

    將 `<YOUR_PAT>` 替換為你的 PAT，將 `<YOUR_GITHUB_USERNAME>` 替換為你的 GitHub 用戶名。

### 5. **MongoDB 卷的權限管理(linux問題)**

在 MongoDB 服務中，我們使用了特定的用戶和組來管理卷的權限。確保你正確設置了卷的權限以避免容器訪問問題：

在宿主機上，確保目錄擁有正確的權限：

```bash
sudo chown -R 1000:1000 ../mongodb/configdb
sudo chown -R 1000:1000 ../mongodb/data
```

這將確保 MongoDB 容器可以正確讀取和寫入配置和數據卷。
