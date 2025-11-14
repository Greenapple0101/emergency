# 🚀 EC2 배포 가이드 (수정 버전)

## ✅ 해결된 문제

- ❌ 이전: JAR 파일이 없어서 COPY 실패
- ✅ 현재: Docker 내부에서 자동으로 JAR 빌드

## 📋 배포 순서

### 1. 코드 가져오기

```bash
cd ~/emergency
git pull origin main
```

### 2. Docker 완전 초기화 (선택사항)

```bash
docker rm -f $(docker ps -aq) 2>/dev/null
docker system prune -a --volumes -f
```

### 3. Docker Compose로 빌드 및 실행

```bash
cd ~/emergency
docker compose down --remove-orphans
docker compose up -d --build
```

**끝!** 이제 Docker가 자동으로:
1. 백엔드 소스 코드를 받아서
2. Gradle로 JAR 빌드하고
3. 실행까지 해줍니다.

## ✅ 확인

```bash
# 컨테이너 상태
docker compose ps

# 로그 확인
docker compose logs -f backend

# Health Check
curl http://localhost:8080/actuator/health
```

## 🔧 문제 해결

### 빌드가 느릴 때
- 첫 빌드는 Gradle 의존성 다운로드로 시간이 걸립니다 (5-10분)
- 이후 빌드는 캐시로 빠릅니다

### 메모리 부족 시
```bash
# Docker 메모리 확인
docker stats

# 필요시 스왑 추가 또는 인스턴스 타입 업그레이드
```

### 포트 충돌
```bash
# 사용 중인 포트 확인
sudo lsof -i :8080
sudo lsof -i :80
```

