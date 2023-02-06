FROM adoptopenjdk/openjdk11
LABEL name="Microservice1"
LABEL version="1.0.0"
LABEL description="Docker based microservice1 application"

COPY ../target/microservice1-1.0.0.jar /usr/opt/app/
WORKDIR /usr/opt/app
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "microservice1-1.0.0.jar"]

