# 멀티 스테이지 빌드: Docker 내부에서 JAR 빌드
# lib 폴더 없이도 Maven Central에서 의존성 다운로드 가능

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

# 빌드된 JAR 파일 복사
COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
