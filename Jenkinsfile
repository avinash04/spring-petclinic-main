node {
    /* Docker Repository */
    def server = '192.168.0.13:8082/docker-virtual'
    def serverUrl = "http://${server}"
    def imageName = 'spring-petclinic-2.4.6'
    def imageVersion = "${env.BUILD_NUMBER}"
    stage('Mvn Package') {
       def mvnHome = tool name: 'maven-3', type: 'maven'
       def mvn = "${mvnHome}/bin/mvn"
       /*Compile code and run test cases using Maven*/
       sh "${mvn} clean package"
    }

    stage('Build Docker image') {
        /*builds the image to Docker build with project name and incremental build number*/
        dockerImage = docker.build("${server}/${imageName}:${imageVersion}")
    }

    stage('Push Docker image') {
         /* Pushing Docker image to JFrog Docker Repository */
         docker.withRegistry("${serverUrl}", 'jfrog-artifact') {
            dockerImage.push()
         }
    }

    stage('Send Email') {
         emailext body: "Build Completed...Docker Tag ${server}/${imageName}:${imageVersion} released",
         recipientProviders: [buildUser()], subject: "Build Status #${imageVersion}", to: 'jha.avinash04@gmail.com'
    }
}
