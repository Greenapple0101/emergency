# 멀티 스테이지 빌드: Docker 내부에서 JAR 빌드
# 여러 JAR 파일이 있어도 안전하게 처리

# Stage 1: 빌드
FROM eclipse-temurin:17-jdk-alpine AS build

WORKDIR /app

# Gradle Wrapper와 설정 파일 복사
COPY gradlew .
COPY gradle ./gradle
COPY build.gradle .
COPY settings.gradle .

# 소스 코드 복사
COPY src ./src

# 실행 권한 부여
RUN chmod +x ./gradlew

# JAR 파일 빌드 (Maven Central에서 의존성 자동 다운로드)
RUN ./gradlew clean build -x test --no-daemon

# Stage 2: 실행
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# 모든 JAR 파일을 디렉토리로 복사 (여러 파일 허용)
COPY --from=build /app/build/libs/*.jar /app/libs/

# SNAPSHOT JAR만 app.jar로 이름 변경 (plain.jar 제외)
RUN mv /app/libs/*SNAPSHOT.jar /app/app.jar 2>/dev/null || \
    mv /app/libs/*.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
