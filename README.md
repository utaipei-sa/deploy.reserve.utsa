# deploy.reserve.utsa

## 1. 腳本簡介
此脚本用于管理名为 `reserve` 的应用程序的 Docker 容器。它支持两个主要命令：
- `SERVICE_UP`：启动所有相关服务。
- `UPDATE_IMAGE`：更新后端和前端镜像，重启 nginx，并删除旧的 Docker 镜像。

## 2. 使用方式
可以通过以下格式从命令行执行此脚本：

```bash
./scripts/cicd.sh <COMMAND> <BACKEND_VERSION> <FRONTEND_VERSION>