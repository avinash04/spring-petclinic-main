node {
    def server = Artifactory.newServer url: 'http://localhost:8082/artifactory', username: 'admin', password: 'password'
    def rtMaven = Artifactory.newMavenBuild()
    def rtDocker
    def buildInfo


    stage ('Artifactory configuration') {
        // Obtain an Artifactory server instance, defined in Jenkins --> Manage Jenkins --> Configure System:

        // Tool name from Jenkins configuration
        rtMaven.tool = 'maven 3.6.3'
        rtMaven.deployer releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot', server: server
        rtMaven.resolver releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot', server: server
        rtDocker = Artifactory.docker server: server
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
             docker.build(ARTIFACTORY_DOCKER_REGISTRY + '/spring-petclinic:latest', 'src/main/resources')
     }

     stage ('Push image to Artifactory') {
             rtDocker.push ARTIFACTORY_DOCKER_REGISTRY + '/spring-petclinic:latest', 'docker-virtual', buildInfo
     }

     stage ('Publish build info') {
             server.publishBuildInfo buildInfo
     }
}
