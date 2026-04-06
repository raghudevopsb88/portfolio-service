FROM        dhi.io/gradle:9-jdk21-alpine3.23-dev AS builder
WORKDIR     /app
COPY        ./ /app/
RUN         chmod +x ./gradlew && ./gradlew bootJar --no-daemon -x test

FROM        docker.io/redhat/ubi9
COPY        --from=builder  /app/build/libs/portfolio-service.jar .
ENTRYPOINT  [ "java", "-jar", "./portfolio-service.jar" ]
