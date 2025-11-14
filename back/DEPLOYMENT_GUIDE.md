# 🚀 SCA-BE 배포 및 연결 가이드

## ✅ 완료된 작업
- [x] MySQL 컨테이너 정상 실행
- [x] sca_db 데이터베이스 생성
- [x] schema.sql 성공적으로 import
- [x] 모든 테이블 생성 완료 (16개)

---

## 📌 1. 백엔드 환경변수 설정

### Docker 컨테이너 실행 시 환경변수

```bash
docker run -d \
  --name sca-backend \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  -e DB_URL=jdbc:mysql://sca-db:3306/sca_db?useSSL=false&serverTimezone=Asia/Seoul&characterEncoding=UTF-8 \
  -e DB_USERNAME=root \
  -e DB_PASSWORD=1234 \
  -e JWT_SECRET=your-secret-key-must-be-at-least-256-bits-long-for-HS256-algorithm-security \
  -e JWT_EXPIRATION=900000 \
  -e JWT_REFRESH_EXPIRATION=604800000 \
  sca-backend:latest
```

### 또는 docker-compose.yml 사용

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: sca-db
    environment:
      MYSQL_ROOT_PASSWORD: 1234
      MYSQL_DATABASE: sca_db
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - sca-network

  backend:
    build: .
    container_name: sca-backend
    ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: prod
      DB_URL: jdbc:mysql://mysql:3306/sca_db?useSSL=false&serverTimezone=Asia/Seoul&characterEncoding=UTF-8
      DB_USERNAME: root
      DB_PASSWORD: 1234
      JWT_SECRET: your-secret-key-must-be-at-least-256-bits-long-for-HS256-algorithm-security
      JWT_EXPIRATION: 900000
      JWT_REFRESH_EXPIRATION: 604800000
    depends_on:
      - mysql
    networks:
      - sca-network

volumes:
  mysql_data:

networks:
  sca-network:
    driver: bridge
```

---

## 📌 2. 백엔드 빌드 및 실행

### 로컬에서 빌드
```bash
cd /Users/baegseoyeon/Desktop/중요/back
./gradlew clean build -x test
```

### JAR 파일 실행 (로컬 테스트)
```bash
java -jar build/libs/sca-be-0.0.1-SNAPSHOT.jar \
  --spring.profiles.active=prod \
  --spring.datasource.url=jdbc:mysql://localhost:3306/sca_db?useSSL=false&serverTimezone=Asia/Seoul \
  --spring.datasource.username=root \
  --spring.datasource.password=1234 \
  --jwt.secret=your-secret-key-must-be-at-least-256-bits-long-for-HS256-algorithm-security \
  --jwt.expiration=900000 \
  --jwt.refresh-expiration=604800000
```

---

## 📌 3. 연결 테스트

### Health Check
```bash
curl http://localhost:8080/actuator/health
```

**예상 응답:**
```json
{
  "status": "UP"
}
```

### Swagger UI 접속
```
http://localhost:8080/swagger-ui/index.html
```

---

## 📌 4. API 테스트 순서

### 1) 선생님 회원가입
```bash
curl -X POST http://localhost:8080/api/v1/auth/teacher/signup \
  -H "Content-Type: application/json" \
  -d '{
    "username": "teacher1",
    "password": "password123",
    "realName": "김선생",
    "nickname": "선생님",
    "email": "teacher@example.com"
  }'
```

### 2) 학생 회원가입
```bash
curl -X POST http://localhost:8080/api/v1/auth/student/signup \
  -H "Content-Type: application/json" \
  -d '{
    "username": "student1",
    "password": "password123",
    "realName": "이학생",
    "nickname": "학생1",
    "email": "student@example.com",
    "inviteCode": "CLASS001"
  }'
```

### 3) 로그인
```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "teacher1",
    "password": "password123"
  }'
```

**응답 예시:**
```json
{
  "success": true,
  "message": "로그인 성공",
  "data": {
    "userType": "teacher",
    "teacherId": 1,
    "username": "teacher1",
    "email": "teacher@example.com",
    "realName": "김선생",
    "nickname": "선생님",
    "role": "ROLE_TEACHER",
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "tokenType": "Bearer",
    "expiresIn": 900000
  }
}
```

### 4) 인증이 필요한 API 호출 (토큰 사용)
```bash
curl -X GET http://localhost:8080/api/v1/classes \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

---

## 📌 5. 문제 해결

### DB 연결 실패 시
1. MySQL 컨테이너가 실행 중인지 확인
   ```bash
   docker ps | grep mysql
   ```

2. 네트워크 확인
   ```bash
   docker network ls
   docker network inspect sca-network
   ```

3. 로그 확인
   ```bash
   docker logs sca-backend
   ```

### 스키마 검증 실패 시
- `ddl-auto: validate`는 테이블이 이미 존재해야 함
- schema.sql이 정상적으로 실행되었는지 확인
  ```bash
  mysql -u root -p sca_db -e "SHOW TABLES;"
  ```

---

## 📌 6. 발표 전 체크리스트

- [ ] MySQL 컨테이너 실행 중
- [ ] 백엔드 컨테이너 실행 중
- [ ] Health Check 응답 확인
- [ ] 회원가입 API 테스트 성공
- [ ] 로그인 API 테스트 성공
- [ ] JWT 토큰 정상 발급 확인
- [ ] 프론트엔드와 연결 테스트
- [ ] Swagger UI 접속 가능

---

## 🎯 발표용 핵심 포인트

1. **MySQL 스키마**: 16개 테이블 정상 생성 완료
2. **백엔드 연결**: Spring Boot + MySQL 정상 작동
3. **API 인증**: JWT 기반 인증 시스템 구축
4. **배포 준비**: Docker 컨테이너 기반 배포 환경 구성

