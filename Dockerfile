FROM maven:3.6.3-ibmjava-8-alpine
COPY . /src
WORKDIR /src
RUN mvn install -DskipTests

FROM openjdk:8-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} spring-petclinic-2.4.6.jar
ENTRYPOINT ["java","-jar", "spring-petclinic-2.4.6.jar"]
