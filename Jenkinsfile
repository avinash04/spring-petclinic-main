node {
    stage('Mvn Package') {
                def mvnHome = tool name: 'maven-3', type: 'maven'
                def mvnCMD = "${mvnHome}/bin/mvn"
                sh "${mvnCMD} clean package"
    }
    stage('Build Docker Image') {
            echo "....Docker Build Started...."
            sh 'docker build -t avinash04/my-docker:spring-petclinic-2.4.6 .'
    }

    stage('Push Docker Image') {
            def server = '192.168.0.13:8082/docker-virtual'
            def imageName = 'spring-petclinic-2.4.6'
            def imageVersion = '1a2b3c'

            withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerhubP')]) {
                sh "docker login -u avinash04 -p ${dockerhubP}"
            }
            sh "docker push avinash04/my-docker:${imageName}"
            sh "docker tag avinash04/my-docker:${imageName} ${server}/${imageName}:${imageVersion}"

            withCredentials([string(credentialsId: 'artifact-pwd', variable: 'artifactPwd')]) {
                sh "docker login ${server} -u admin -p ${artifactPwd}"
            }
            sh "docker push ${server}/${imageName}:${imageVersion}"
    }
}
