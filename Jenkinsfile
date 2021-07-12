node {
    /* Docker Repository */
    environment {
        REPO_CREDS = credentials('jfrog-artifact')
        REPO_USERNAME = "$REPO_CREDS_USR"
        REPO_USERNAME = "$REPO_CREDS_PSW"
        //MVN_SETTINGS = credentials('mvnSetting')
    }
    def artifactoryUrl = 'http://192.168.0.13:8082/artifactory/maven-remote'
    def server = Artifactory.server 'SERVER_ID'
    //def server = Artifactory.newServer url: "${artifactoryUrl}", credentialsId: 'jfrog-artifact'
    def dockerServer = '192.168.0.13:8082/docker-virtual'
    //def server.credentialsId = 'jfrog-artifact'
    def dockerServerUrl = "http://${dockerServer}"
    def imageName = 'spring-petclinic-2.4.6'
    def imageVersion = "${env.BUILD_NUMBER}"
    def rtMaven = Artifactory.newMavenBuild()

    stage ('Artifactory configuration') {
        rtMaven.tool = 'maven-3'
        rtMaven.deployer releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot', server: server
        rtMaven.resolver releaseRepo: 'maven-remote', snapshotRepo: 'maven-remote', server: server
        buildInfo = Artifactory.newBuildInfo()
    }

    stage ('Exec Maven') {
            rtMaven.run pom: 'pom.xml', goals: 'clean install', buildInfo: buildInfo
    }

//     stage('Mvn Package') {
//        def mvnHome = tool name: 'maven-3', type: 'maven'
//        def mvn = "${mvnHome}/bin/mvn"
//        /*Compile code and run test cases using Maven*/
//        //sh "${mvn} -s $MVN_SETTINGS clean install"
//        withCredentials([file(credentialsId: 'mvnSetting', variable: 'MVN_SETTINGS')]) {
//            sh "${mvn} -s ${MVN_SETTINGS} clean install"
//        }
//     }

    stage('Build Docker image') {
        /*builds the image to Docker build with project name and incremental build number*/
        dockerImage = docker.build("${dockerServer}/${imageName}:${imageVersion}")
    }

    stage('Push Docker image') {
         /* Pushing Docker image to JFrog Docker Repository created locally*/
         docker.withRegistry("${dockerServerUrl}", '$REPO_CREDS') {
            dockerImage.push()
         }
    }

    stage ('Publish build info') {
         server.publishBuildInfo buildInfo
    }

    stage('Send Email') {
         emailext body: "Build Completed...Docker Tag ${dockerServer}/${imageName}:${imageVersion} released",
         recipientProviders: [buildUser()], subject: "Build Status #${imageVersion}", to: 'jha.avinash04@gmail.com'
    }
}
