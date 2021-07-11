FROM jenkins/jenkins:lts
USER root
RUN apt-get update && apt-get install -y maven
RUN mvn install

FROM openjdk:8-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} spring-petclinic-2.4.6.jar
ENTRYPOINT ["java","-jar", "spring-petclinic-2.4.6.jar"]
