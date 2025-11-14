#!/bin/bash

# 🚀 Jenkins 배포 스크립트
# 서버: http://16.176.15.30

set -e

echo "=========================================="
echo "🚀 SCA-BE Jenkins 배포 시작"
echo "=========================================="
echo ""

# 환경 변수
SERVER_URL="16.176.15.30"
BUILD_NUMBER="${BUILD_NUMBER:-latest}"
IMAGE_NAME="sca-backend"

# 1. 빌드
echo "1️⃣ Gradle 빌드..."
chmod +x ./gradlew
./gradlew clean build -x test

# 2. Docker 이미지 빌드
echo ""
echo "2️⃣ Docker 이미지 빌드..."
docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${IMAGE_NAME}:latest

# 3. 배포 (Docker Compose)
echo ""
echo "3️⃣ 배포 시작..."
# 외부 MySQL 사용 시: docker-compose.server.yml 사용
# 로컬 MySQL 사용 시: docker-compose.yml 사용
COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.server.yml}"
docker compose -f ${COMPOSE_FILE} down || true
docker compose -f ${COMPOSE_FILE} up -d --build

# 4. Health Check
echo ""
echo "4️⃣ Health Check 대기..."
MAX_ATTEMPTS=30
ATTEMPT=0
HEALTHY=false

while [ $ATTEMPT -lt $MAX_ATTEMPTS ] && [ "$HEALTHY" = false ]; do
    sleep 10
    ATTEMPT=$((ATTEMPT + 1))
    
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://${SERVER_URL}:8080/actuator/health || echo "000")
    
    if [ "$HTTP_CODE" = "200" ]; then
        HEALTHY=true
        echo "✅ Health Check 성공! (시도 ${ATTEMPT}/${MAX_ATTEMPTS})"
    else
        echo "⏳ Health Check 대기 중... (시도 ${ATTEMPT}/${MAX_ATTEMPTS}, HTTP ${HTTP_CODE})"
    fi
done

if [ "$HEALTHY" = false ]; then
    echo "❌ Health Check 실패!"
    exit 1
fi

# 5. Smoke Test
echo ""
echo "5️⃣ Smoke Test..."
HEALTH_RESPONSE=$(curl -s http://${SERVER_URL}:8080/actuator/health)
echo "Health Check 응답: $HEALTH_RESPONSE"

if echo "$HEALTH_RESPONSE" | grep -q "UP"; then
    echo "✅ Smoke Test 통과!"
else
    echo "❌ Smoke Test 실패!"
    exit 1
fi

echo ""
echo "=========================================="
echo "🎉 배포 완료!"
echo "=========================================="
echo "서버 URL: http://${SERVER_URL}:8080"
echo "Swagger UI: http://${SERVER_URL}:8080/swagger-ui/index.html"
echo "Health Check: http://${SERVER_URL}:8080/actuator/health"
echo ""

