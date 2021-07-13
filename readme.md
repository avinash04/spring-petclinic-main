# Spring PetClinic Sample Application [![Build Status](https://travis-ci.org/spring-projects/spring-petclinic.png?branch=main)](https://travis-ci.org/spring-projects/spring-petclinic/)

## Understanding the Spring Petclinic application with a few diagrams
<a href="https://speakerdeck.com/michaelisvy/spring-petclinic-sample-application">See the presentation here</a>

## Running petclinic locally
Petclinic is a [Spring Boot](https://spring.io/guides/gs/spring-boot) application built using [Maven](https://spring.io/guides/gs/maven/). You can build a jar file and run it from the command line:


```
git clone https://github.com/avinash04/spring-petclinic-main.git
cd spring-petclinic
./mvnw package
java -jar target/*.jar
```

You can then access petclinic here: http://localhost:80/

<img width="1042" alt="petclinic-screenshot" src="https://cloud.githubusercontent.com/assets/838318/19727082/2aee6d6c-9b8e-11e6-81fe-e889a5ddfded.png">


### Jenkins Pipeline Created with Jenkinsfile

Performing below operations:

1) Compile the code
2) Run Tests
3) Resolve dependencies against remote artifactory configured in JFrog repository which internally pointed to Maven repo (instead of JCenter)
   Note: As per my research, Bintray account needed for JCenter. 
   However, I am unable to create new account as it is going sunset and led me to this page:
   <a href="https://jfrog.com/blog/into-the-sunset-bintray-jcenter-gocenter-and-chartcenter">Into the Sunset</a>
4) Package the project as a runnable Docker image
5) Publish docker image to JFrog Artifactory (created as Docker Registry)

### Steps taken to achieve above tasks

1) Set up Jenkins docker
   - Start Jenkins docker 
     (Sample: docker run -d --name=avinash04/jenkins -p8080:8080 -v /var/run/docker.sock:/var/run/docker.sock $JENKINS_IMAGE_NAME)
     Replace JENKINS_IMAGE_NAME with your image and -v /var/run/docker.sock:/var/run/docker.sock to provide docker support within jenkins container
   - Set up Jenkins and install Required plugins:- GitHub, Docker, Artifactory, Docker Pipeline.
   - Set up GitHub configuration to connect it to Repo and add webhook in GitHub to enable jenkins build on push.
     Note: Since jenkins is running locally, we need to use ngork, Something like this:
     ngrok http 8080
     Update output url as webhook in github->Setting->webhooks
   - Under Global Tool Configuration set up maven installation and assign maven name which will later be used in Jenkinsfile
   
2) Set up Artifactory by running docker image
   Refer: <a href="https://jfrog.com/artifactory/install/">Docker Artifctory installation</a>

3) Create local, Remote and Virtual Repository for the Docker
   Set up artifactory as docker registry using Repository path as Embedded Tomcat
   
   Follow steps on : <a href="https://www.jfrog.com/confluence/display/JFROG/Getting+Started+with+Artifactory+as+a+Docker+Registry#GettingStartedwithArtifactoryasaDockerRegistry-GettingStartedwithArtifactoryProOn-Prem">Getting Started with Artifactory as a Docker Registry</a>
   
4) Create DockerFile
   - Create DockerFile which has maven, java support to create docker image
   - Copy generated jar to docker image and include entrypoint to run application

5) Create Jenkinsfile
   - Create Jenkinsfile and add scripts to run pipeline (we can use pipeline syntax in jenkin for reference)
   - Checkout specific branch to build the code
   - Add maven task packgae which will compile, run tests (Use maven name defined in step 1)
   - Resolve the dependencies against Artifactory
   - Deploy artifacts to local JFrog artifactory
   - Build Docker Image
   - Push Docker Image
   - Publish image using docker registry with build number used as tag 
     (sample tag: $ARTIFACTORY_REGISTRY/spring-petclinic-2.4.6:21)
   - Send Email Notification

6) Additional Code changes
   - Add Jenkinsfile, DockerFile to the project
   - Added server.port with new port in application properties (Optional)
   - Push changes to the github
   
7) Monitor Jenkin pipeline
   - Verify all the tasks completed
   - Check for the image in docker repository
   - Verify if email received with Subject Build Status #BUILD_NUMBER
     Sample Email body: "Build Completed...Docker Tag $ARTIFACTORY_REGISTRY/spring-petclinic-2.4.6:22 released"

8) Run the application from docker image
   - Since artifactory was used as docker registry, running below command will run the application
     docker run -d -p 80:8080 $ARTIFACTORY_REGISTRY/spring-petclinic-2.4.6:22

9) Navigate to Petclinic

    Visit [http://localhost:80](http://localhost:80) in your browser.
    


## Ways to use docker image

1) Using dockerhub uploaded image
Docker image was already updated to my dockerhub repo

Pull docker image
"docker pull avinash04/my-docker:petclinic-2.0"

Run Docker Image
"docker run -d -it -p 80:8080 --name=clinic avinash04/my-docker:petclinic-2.0"

Visit [http://localhost:80](http://localhost:80) in your browser.

2) Image zip sent as an attachment

Load the image from tar file
"docker load < myDockerImage.tar"

Run the unzipped image with container
"docker run -d -it -p 80:8080 --name=clinic avinash04/my-docker:petclinic-2.0"
