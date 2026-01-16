#!/bin/bash

# Kiro2API 一键部署脚本
# 直接运行 ./deploy.sh 即可自动: 停止 → 拉取最新 → 启动

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# 项目目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}       Kiro2API 一键部署${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# 检查 Docker Compose
if docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
elif command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
else
    echo -e "${RED}错误: Docker Compose 未安装${NC}"
    exit 1
fi

# 创建必要目录和配置
mkdir -p "$SCRIPT_DIR/data"
[ ! -f "$SCRIPT_DIR/.env" ] && cp "$SCRIPT_DIR/.env.example" "$SCRIPT_DIR/.env" 2>/dev/null || true

# 一键部署流程
echo -e "${YELLOW}[1/3] 停止旧服务...${NC}"
$COMPOSE_CMD down 2>/dev/null || true

echo -e "${YELLOW}[2/3] 拉取最新镜像...${NC}"
$COMPOSE_CMD pull

echo -e "${YELLOW}[3/3] 启动服务...${NC}"
$COMPOSE_CMD up -d

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ 部署完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "访问地址: ${BLUE}http://localhost:8000${NC}"
echo ""
echo -e "查看日志: ${YELLOW}docker compose logs -f${NC}"
