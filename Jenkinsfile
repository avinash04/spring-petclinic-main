pipeline {
    agent { docker { image 'maven:3.6.3' } }
    stages {
        stage('build') {
            steps {
                sh 'mvn --version'
                sh 'mvn -B -DskipTests clean package'
                echo "Build Successful"
            }
        }
        stage ('Test') {
            steps {
                 sh 'mvn test'
            }
            post {
                  always {
                          junit 'target/surefire-reports/*.xml'
                  }
            }
         }
    }
}
