node {
//     agent {
//         docker {
//             image 'maven:3-alpine'
//             args '--user root -v $HOME/.m2:/root/.m2  -v /var/run/docker.sock:/var/run/docker.sock'
//         }
//     }

    stage('Mvn Package') {
                def mvnHome = tool name: 'maven-3', type: 'maven'
                def mvnCMD = "${mvnHome}/bin/mvn"
                sh "${mvnCMD} clean package"
    }
    stage('Build Docker Image') {
            sh 'docker build -t avinash04/my-docker:spring-petclinic-2.4.6 .'
    }

    stage('Push Docker Image') {
            def server = '192.168.0.13:8082/docker-virtual'
//             withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerhubP')]) {
//                 sh "docker login -u avinash04 -p ${dockerhubP}"
//             }
            withCredentials([string(credentialsId: 'artifact-pwd', variable: 'artifactPwd')]) {
                sh "docker login ${server} -u admin -p ${artifactPwd}"
            }
            sh "docker tag avinash04/my-docker:latest ${server}/spring-petclinic:1a2b3c"
            sh "docker push ${server}/spring-petclinic:1a2b3c"
    }

    //stage()
//     stages {
//         stage('Build') {
//             steps {
//                 sh 'mvn -B -DskipTests clean package'
//             }
//         }
//         stage('Test') {
//             steps {
//                 sh 'mvn test'
//             }
//             post {
//                 always {
//                     junit 'target/surefire-reports/*.xml'
//                 }
//             }
//         }
//         stage('Deliver') {
//             steps {
//                 sh './jenkins/scripts/deliver.sh'
//             }
//         }
//     }
}
