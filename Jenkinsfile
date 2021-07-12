node {
    def server = '192.168.0.13:8082/docker-virtual'
    def imageName = 'spring-petclinic-2.4.6'
    def imageVersion = '2a1c34'
    def dockerImage = ''
    environment {
        registryCredentialSet = 'artifact-pwd'
    }
    stage('Mvn Package') {
                def mvnHome = tool name: 'maven-3', type: 'maven'
                def mvnCMD = "${mvnHome}/bin/mvn"
                sh "${mvnCMD} clean package"
    }
    stage('Build Docker Image') {
            echo "....Docker Build Started...."
            // This is DockerHub Build
            //sh 'docker build -t avinash04/my-docker:spring-petclinic-2.4.6 .'
            //sh "docker build -t ${server}/${imageName}:${imageVersion} ."
            dockerImage = docker.build ${server} + "${imageName}:${imageVersion}"
    }

    stage('Push Docker Image') {
    // This is DockerHub Push
//             withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerhubP')]) {
//                 sh "docker login -u avinash04 -p ${dockerhubP}"
//             }
//             sh "docker push avinash04/my-docker:${imageName}"
//             sh "docker tag avinash04/my-docker:${imageName} ${server}/${imageName}:${imageVersion}"

            // Login to Docker registry artifactory and push the image build above
//             withCredentials([string(credentialsId: 'artifact-pwd')]) {
//                 sh 'docker login ${server} -u admin -p $artifact-pwd'
//             }
//             sh "docker push ${server}/${imageName}:${imageVersion}"

            docker.withRegistry(${server}, registryCredentialSet){
                //sh "docker push ${server}/${imageName}:${imageVersion}"
                dockerImage.push()
            }
    }
}
