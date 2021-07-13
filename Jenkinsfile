node {
    def server = Artifactory.server 'SERVER_ID'
    def dockerServer = '192.168.0.13:8082/docker-virtual'
    def dockerServerUrl = "http://${dockerServer}"
    def imageName = 'spring-petclinic-2.4.6'
    def imageVersion = "${env.BUILD_NUMBER}"
    def rtMaven = Artifactory.newMavenBuild()

    stage ('Clone') {
            git url: 'https://github.com/avinash04/spring-petclinic-main.git', branch: '2.0-dev'
    }

    stage ('Artifactory configuration') {
        rtMaven.tool = 'maven-3'
        rtMaven.deployer releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot', server: server
        rtMaven.resolver releaseRepo: 'maven-remote', snapshotRepo: 'maven-remote', server: server
        buildInfo = Artifactory.newBuildInfo()
    }

    stage ('Exec Maven') {
            rtMaven.run pom: 'pom.xml', goals: 'clean install', buildInfo: buildInfo
    }

    stage('Build Docker image') {
        /*builds the image to Docker build with project name and incremental build number*/
        dockerImage = docker.build("${dockerServer}/${imageName}:${imageVersion}")
    }

    stage('Push Docker image') {
         /* Pushing Docker image to JFrog Docker Repository created locally*/
         docker.withRegistry("${dockerServerUrl}", 'jfrog-artifact') {
            dockerImage.push()
         }
    }

    stage ('Publish build info') {
         server.publishBuildInfo buildInfo
    }

    stage('Send Email') {
         emailext body: "Build Completed...Docker Tag ${dockerServer}/${imageName}:${imageVersion} released",
         recipientProviders: [developers(), buildUser()], subject: "Build Status: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'", to: 'jha.avinash04@gmail.com'
    }
}
