#!/bin/bash

# 백엔드 JAR 빌드 스크립트

set -e

echo "=========================================="
echo "🔨 백엔드 JAR 빌드 시작"
echo "=========================================="
echo ""

# Gradle Wrapper 실행 권한 부여
chmod +x ./gradlew

# JAR 빌드
echo "Gradle 빌드 실행 중..."
./gradlew clean build -x test

# 빌드 결과 확인
if [ -f "build/libs/*.jar" ]; then
    echo ""
    echo "✅ JAR 빌드 성공!"
    echo "생성된 JAR 파일:"
    ls -lh build/libs/*.jar
else
    echo ""
    echo "❌ JAR 빌드 실패!"
    exit 1
fi

echo ""
echo "=========================================="
echo "🎉 빌드 완료!"
echo "=========================================="

