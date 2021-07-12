node {
    def server = '192.168.0.13:8082/docker-virtual'
    def serverUrl = "http://${server}"
    def imageName = 'spring-petclinic-2.4.6'
    def imageVersion = "${env.BUILD_NUMBER}"
    stage('Mvn Package') {
       def mvnHome = tool name: 'maven-3', type: 'maven'
       def mvnCMD = "${mvnHome}/bin/mvn"
       sh "${mvnCMD} clean package"
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
         emailext body: 'Build Completed!!!', recipientProviders: [buildUser()], subject: 'Build Status', to: 'jha.avinash04@gmail.com'
    }
}
