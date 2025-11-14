FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# JAR 파일 복사 (EC2에서 미리 빌드된 JAR 사용)
COPY build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
