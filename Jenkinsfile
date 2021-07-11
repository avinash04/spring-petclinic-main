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
            withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerhubP')]) {
                sh "docker login -u avinash04 -p ${dockerhubP}"
            }
            sh 'docker push avinash04/my-docker:spring-petclinic-2.4.6'
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
