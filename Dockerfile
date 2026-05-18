FROM        docker.io/library/openjdk:21-ea AS builder
WORKDIR     /app
COPY        ./ /app/
RUN         chmod +x ./gradlew && ./gradlew bootJar --no-daemon -x test

FROM        sonarsource/sonar-scanner-cli AS sonar-scanner
WORKDIR     /usr/src
# Copy source code from the builder stage to scan it
COPY        --from=builder /app /usr/src
# Define build arguments for SonarQube credentials
ARG         SONAR_HOST_URL
ARG         SONAR_TOKEN
# Run the scanner (fails the build if quality gate fails, optional)
RUN         sonar-scanner \
            -Dsonar.host.url=http://172.31.17.79:9000 \
            -Dsonar.login=admin -Dsonar.password=admin123 -Dsonar.qualitygate.wait=true \
            -Dsonar.projectKey=portfolio-service \
            -Dsonar.sources=. -Dsonar.java.binaries=./build/classes

FROM        docker.io/library/openjdk:21-ea
COPY        --from=builder  /app/build/libs/*.jar portfolio-service.jar
ENTRYPOINT  [ "java", "-jar", "./portfolio-service.jar" ]

