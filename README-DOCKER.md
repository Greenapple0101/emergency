# 🐳 Docker 빌드 및 실행 가이드

## 사전 요구사항

1. **Docker Desktop** 설치 및 실행
2. Docker 데몬이 실행 중이어야 합니다

## 빠른 시작

### 개발 환경 (MySQL 불필요, H2 사용)

```bash
# 방법 1: 스크립트 사용
./build-and-run.sh dev

# 방법 2: 수동 실행
docker compose -f docker-compose.dev.yml up -d --build
```

### 프로덕션 환경 (MySQL 포함)

```bash
# 방법 1: 스크립트 사용
./build-and-run.sh prod

# 방법 2: 수동 실행
docker compose up -d --build
```

### 서버 배포

서버 배포는 `DEPLOYMENT.md` 참고

## 서비스 접속 정보

- **프론트엔드**: http://localhost:3000
- **백엔드 API**: http://localhost:8080
- **MySQL**: localhost:3306
  - 사용자: root
  - 비밀번호: 1234
  - 데이터베이스: sca_db

## 유용한 명령어

```bash
# 컨테이너 상태 확인
docker compose ps

# 로그 확인
docker compose logs -f [서비스명]

# 특정 서비스 재시작
docker compose restart [서비스명]

# 모든 컨테이너 중지
docker compose down

# 모든 컨테이너 중지 및 볼륨 삭제
docker compose down -v

# 백엔드만 재빌드
docker compose build backend

# 프론트엔드만 재빌드
docker compose build frontend
```

## 문제 해결

### Docker 데몬이 실행되지 않는 경우
```bash
# Docker Desktop을 시작하거나
open -a Docker
```

### 포트가 이미 사용 중인 경우
`docker-compose.yml`에서 포트 번호를 변경하세요:
- 프론트엔드: `3000:80` → `3001:80`
- 백엔드: `8080:8080` → `8081:8080`
- MySQL: `3306:3306` → `3307:3306`

### 빌드 실패 시
```bash
# 캐시 없이 재빌드
docker compose build --no-cache
```

## 구조

```
docker-compose.yml
├── mysql (MySQL 8.0)
├── backend (Spring Boot - 포트 8080)
└── frontend (Nginx - 포트 3000)
```

## 네트워크

모든 서비스는 `sca-network` 네트워크에 연결되어 있으며, 서비스 이름으로 서로 통신할 수 있습니다:
- 프론트엔드 → 백엔드: `http://backend:8080`
- 백엔드 → MySQL: `mysql:3306`

