pipeline {
    agent {
        docker {
            image 'maven:3-alpine' 
            args '--user root -v $HOME/.m2:/root/.m2  -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    stages {
        stage('Build') { 
            steps {
                sh 'mvn -B -DskipTests clean package' 
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Deliver') {
            steps {
                sh './jenkins/scripts/deliver.sh'
            }
        }
    }
}
