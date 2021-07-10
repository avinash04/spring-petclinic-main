node {
    def server = Artifactory.newServer url: 'http://localhost:8081/artifactory', username: 'admin', password: 'password'
    def rtMaven = Artifactory.newMavenBuild()
    def buildInfo


    stage ('Artifactory configuration') {
        // Obtain an Artifactory server instance, defined in Jenkins --> Manage Jenkins --> Configure System:

        // Tool name from Jenkins configuration
        rtMaven.tool = 'maven 3.6.3'
        rtMaven.deployer releaseRepo: 'libs-release-local', snapshotRepo: 'libs-snapshot-local', server: server
        rtMaven.resolver releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot', server: server
        buildInfo = Artifactory.newBuildInfo()
    }

    stage ('Exec Maven') {
        rtMaven.run pom: 'pom.xml', goals: 'clean install', buildInfo: buildInfo
    }

    stage ('Publish build info') {
        server.publishBuildInfo buildInfo
    }
}
