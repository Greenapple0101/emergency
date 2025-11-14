# 🚀 EC2 배포 가이드

## 📋 사전 준비

1. EC2에 접속
2. emergency 폴더로 이동

```bash
cd ~/emergency
git pull origin main
```

## 🔨 백엔드 JAR 빌드 (필수!)

Dockerfile이 JAR 파일을 사용하므로 **먼저 JAR을 빌드**해야 합니다.

```bash
cd ~/emergency/back

# JAR 빌드 스크립트 실행
chmod +x build-jar.sh
./build-jar.sh

# 또는 수동 빌드
chmod +x gradlew
./gradlew clean build -x test
```

빌드 완료 확인:
```bash
ls -lh build/libs/*.jar
```

## 🐳 Docker 배포

### 방법 1: 원클릭 배포 (권장)

```bash
cd ~/emergency
chmod +x deploy.sh
./deploy.sh
```

### 방법 2: 수동 배포

```bash
cd ~/emergency

# 1. Docker 초기화 (선택사항)
docker rm -f $(docker ps -aq) 2>/dev/null
docker system prune -a --volumes -f

# 2. 기존 컨테이너 정리
docker compose down --remove-orphans

# 3. 빌드 및 실행
docker compose up -d --build
```

## ✅ 확인

```bash
# 컨테이너 상태 확인
docker compose ps

# 로그 확인
docker compose logs -f

# 프론트엔드 접속
curl http://localhost

# 백엔드 Health Check
curl http://localhost:8080/actuator/health
```

## 🔧 문제 해결

### JAR 파일이 없을 때
```bash
cd ~/emergency/back
./gradlew clean build -x test
```

### Docker 빌드 실패 시
```bash
# 캐시 없이 재빌드
docker compose build --no-cache
```

### 포트 충돌 시
```bash
# 사용 중인 포트 확인
sudo lsof -i :8080
sudo lsof -i :80

# 프로세스 종료
sudo kill -9 <PID>
```

