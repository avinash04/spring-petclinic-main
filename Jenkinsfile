node {
    def server = Artifactory.newServer url: 'http://localhost:8082/artifactory', username: 'admin', password: 'password'
    def rtMaven = Artifactory.newMavenBuild()
    def rtDocker = Artifactory.docker server: server
    def buildInfo


    stage ('Artifactory configuration') {
        // Obtain an Artifactory server instance, defined in Jenkins --> Manage Jenkins --> Configure System:

        // Tool name from Jenkins configuration
        rtMaven.tool = 'maven 3.6.3'
        rtMaven.deployer releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot', server: server
        rtMaven.resolver releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot', server: server
        buildInfo = Artifactory.newBuildInfo()
    }

    stage ('Exec Maven') {
        rtMaven.run pom: 'pom.xml', goals: 'clean install', buildInfo: buildInfo
    }

    stage ('Add properties') {
            // Attach custom properties to the published artifacts:
            rtDocker.addProperty("project-name", "avidocker").addProperty("status", "stable")
     }

     stage ('Build docker image') {
             docker.build('http://localhost:8082/docker-virtual/spring-petclinic:latest', '.')
     }

     stage ('Push image to Artifactory') {
             rtDocker.push 'http://localhost:8082/docker-virtual/spring-petclinic:latest', 'docker-virtual', buildInfo
     }

     stage ('Publish build info') {
             server.publishBuildInfo buildInfo
     }
}
