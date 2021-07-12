FROM maven:3.5-jdk-8-alpine
COPY . /src
WORKDIR /src
RUN mvn install

RUN sed -i 's/port="8080"/port="9090"/' /usr/local/tomcat/conf/server.xml

FROM openjdk:8-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} spring-petclinic-2.4.6.jar
ENTRYPOINT ["java","-jar", "spring-petclinic-2.4.6.jar"]
