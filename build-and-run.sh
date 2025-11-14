#!/bin/bash

# Docker 빌드 및 실행 스크립트

echo "🚀 SCA 시스템 도커 빌드 및 실행 시작..."

# Docker가 실행 중인지 확인
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker 데몬이 실행 중이 아닙니다. Docker Desktop을 시작해주세요."
    exit 1
fi

# 환경 선택 (dev 또는 prod, 기본값: dev)
ENV=${1:-dev}

if [ "$ENV" = "dev" ]; then
    COMPOSE_FILE="docker-compose.dev.yml"
    echo "🔧 개발 환경 모드 (H2 DB 사용, MySQL 불필요)"
else
    COMPOSE_FILE="docker-compose.yml"
    echo "🔧 프로덕션 환경 모드 (MySQL 포함)"
fi

# 기존 컨테이너 중지 및 제거
echo "🧹 기존 컨테이너 정리 중..."
docker compose -f $COMPOSE_FILE down -v

# 이미지 빌드
echo "🔨 이미지 빌드 중..."
docker compose -f $COMPOSE_FILE build

# 컨테이너 실행
echo "▶️  컨테이너 실행 중..."
docker compose -f $COMPOSE_FILE up -d

# 상태 확인
echo "⏳ 서비스 시작 대기 중..."
sleep 10

echo "✅ 빌드 및 실행 완료!"
echo ""
echo "📋 서비스 접속 정보:"
echo "  - 프론트엔드: http://localhost:3000"
echo "  - 백엔드 API: http://localhost:8080"
echo "  - MySQL: localhost:3306"
echo ""
echo "컨테이너 상태 확인: docker compose ps"
echo "로그 확인: docker compose logs -f"

