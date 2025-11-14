#!/bin/bash

# 🚀 서버 배포 원클릭 스크립트

set -e

echo "=========================================="
echo "🚀 SCA 시스템 배포 시작"
echo "=========================================="
echo ""

# 1. Docker 완전 초기화
echo "1️⃣ Docker 완전 초기화..."
docker rm -f $(docker ps -aq) 2>/dev/null || true
docker system prune -a --volumes -f

# 2. 폴더 구조 확인
echo ""
echo "2️⃣ 폴더 구조 확인..."
if [ -d "./backend" ] && [ -d "./frontend" ]; then
    COMPOSE_FILE="docker-compose.server.yml"
    echo "✅ backend/frontend 구조 감지"
elif [ -d "./back" ] && [ -d "./front" ]; then
    COMPOSE_FILE="docker-compose.yml"
    echo "✅ back/front 구조 감지"
else
    echo "❌ backend 또는 back 폴더를 찾을 수 없습니다!"
    exit 1
fi

# 3. 기존 컨테이너 정리
echo ""
echo "3️⃣ 기존 컨테이너 정리..."
docker compose -f $COMPOSE_FILE down --remove-orphans || true

# 4. 빌드 및 실행
echo ""
echo "4️⃣ 빌드 및 실행..."
docker compose -f $COMPOSE_FILE up -d --build

# 5. 상태 확인
echo ""
echo "5️⃣ 서비스 상태 확인..."
sleep 5
docker compose -f $COMPOSE_FILE ps

echo ""
echo "=========================================="
echo "🎉 배포 완료!"
echo "=========================================="
echo ""
echo "📋 접속 정보:"
echo "  - 프론트엔드: http://16.176.15.30"
echo "  - 백엔드 API: http://16.176.15.30:8080"
echo "  - Health Check: http://16.176.15.30:8080/actuator/health"
echo ""
echo "로그 확인: docker compose -f $COMPOSE_FILE logs -f"

