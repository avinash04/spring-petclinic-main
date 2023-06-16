# Dockerfile for jenkins build
FROM maven:3.6.3-ibmjava-8-alpine
COPY . /src
COPY . /pom.xml
WORKDIR /src
RUN mvn install -DskipTests

FROM openjdk:8-jdk-alpine
ARG JAR_FILE=target/*.jar
#COPY ${JAR_FILE} spring-petclinic-2.4.6.jar
CMD ["echo", "Hello World"]
ENTRYPOINT ["java","-jar", "/src/target/spring-petclinic-2.4.6.jar"]

# Dockerfile for running app from repository
# FROM {DOCKER_REGISTRY}/spring-petclinic-2.4.6:29
# ARG JAR_FILE=target/*.jar
# COPY ${JAR_FILE} spring-petclinic-2.4.6.jar
# ENTRYPOINT ["java","-jar", "spring-petclinic-2.4.6.jar"]

