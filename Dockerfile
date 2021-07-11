FROM maven:3.5-jdk-8-alpine
COPY . /src
WORKDIR /src
RUN mvn install

FROM openjdk:8-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} spring-petclinic-2.4.6.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar", "spring-petclinic-2.4.6.jar"]
