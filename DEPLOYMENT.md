# 🚀 배포 가이드

## 환경별 Docker Compose 파일

### 1. 개발 환경 (로컬 개발용)
**파일**: `docker-compose.dev.yml`
- **MySQL 불필요**: H2 인메모리 DB 사용
- 빠른 시작 가능
- 데이터는 컨테이너 재시작 시 초기화됨

```bash
docker compose -f docker-compose.dev.yml up -d
```

### 2. 프로덕션 환경 (로컬 테스트용)
**파일**: `docker-compose.yml` 또는 `docker-compose.prod.yml`
- **MySQL 포함**: 컨테이너 내 MySQL 사용
- 데이터 영구 저장

```bash
docker compose up -d
# 또는
docker compose -f docker-compose.prod.yml up -d
```

### 3. 서버 배포용
**파일**: `back/docker-compose.server.yml`
- **외부 MySQL 사용 가능**: 환경변수로 DB_URL 설정
- Jenkins에서 사용

## 서버 배포 방법

### 방법 1: Jenkins를 통한 자동 배포 (권장)

#### Jenkins 설정
1. Jenkinsfile이 이미 설정되어 있음
2. Git 저장소 연결
3. 빌드 트리거 설정

#### 필요한 Jenkins Credentials
- `mysql-root-password`: MySQL root 비밀번호
- `jwt-secret`: JWT 시크릿 키

#### 배포 실행
```bash
# Jenkins에서 파이프라인 실행
# 또는 Jenkinsfile의 파라미터 설정:
# - RUN_TESTS: 테스트 실행 여부
# - PUSH_TO_REGISTRY: Docker Registry 푸시 여부
```

### 방법 2: 수동 배포

#### 서버에 SSH 접속 후:

```bash
# 1. 저장소 클론
git clone <저장소 URL>
cd 중요/back

# 2. 환경변수 설정 (.env 파일 또는 export)
export DB_URL="jdbc:mysql://외부MySQL호스트:3306/sca_db?useSSL=false&serverTimezone=Asia/Seoul&characterEncoding=UTF-8"
export DB_USERNAME="root"
export DB_PASSWORD="실제비밀번호"
export JWT_SECRET="실제JWT시크릿키"

# 3. 배포 스크립트 실행
chmod +x jenkins-deploy.sh
./jenkins-deploy.sh

# 또는 직접 docker compose 실행
docker compose -f docker-compose.server.yml up -d --build
```

## MySQL 설정 옵션

### 옵션 1: 외부 MySQL 사용 (서버 배포 시 권장)
- 서버에 별도로 MySQL 설치/운영
- 또는 클라우드 RDS 사용
- `DB_URL` 환경변수로 연결

```bash
export DB_URL="jdbc:mysql://외부호스트:3306/sca_db?useSSL=false&serverTimezone=Asia/Seoul&characterEncoding=UTF-8"
```

### 옵션 2: Docker Compose의 MySQL 사용
- `docker-compose.yml` 또는 `docker-compose.prod.yml` 사용
- MySQL 컨테이너 포함

## 환경별 요약

| 환경 | 파일 | MySQL | 용도 |
|------|------|-------|------|
| 개발 | `docker-compose.dev.yml` | ❌ (H2) | 로컬 개발 |
| 프로덕션(로컬) | `docker-compose.yml` | ✅ (컨테이너) | 로컬 테스트 |
| 서버 배포 | `back/docker-compose.server.yml` | ⚙️ (외부/환경변수) | 실제 서버 |

## Health Check

배포 후 확인:
```bash
curl http://서버주소:8080/actuator/health
```

## 문제 해결

### MySQL 연결 실패
- 외부 MySQL 사용 시 방화벽 확인
- DB_URL 형식 확인
- MySQL 사용자 권한 확인

### 빌드 실패
```bash
# 캐시 없이 재빌드
docker compose build --no-cache
```

### 로그 확인
```bash
docker compose logs -f backend
```

