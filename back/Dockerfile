# 멀티 스테이지 빌드
# Stage 1: 빌드
FROM eclipse-temurin:17-jdk-alpine AS build

WORKDIR /app

# Gradle Wrapper와 build.gradle 복사
COPY gradlew .
COPY gradle ./gradle
COPY build.gradle .
COPY settings.gradle .
COPY lib ./lib

# 소스 코드 복사
COPY src ./src

# 실행 권한 부여
RUN chmod +x ./gradlew

# JAR 파일 빌드
RUN ./gradlew clean build -x test --no-daemon

# Stage 2: 실행
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# 빌드된 JAR 파일 복사
COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
