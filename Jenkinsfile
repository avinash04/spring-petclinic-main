pipeline {
    agent any
    tools {
            maven 'maven 3.6.3'
            jdk 'jdk8'
    }
    stages {

        stage ('Initialize') {
                    steps {
                        sh '''
                            echo "PATH = ${PATH}"
                            echo "M2_HOME = ${MAVEN_HOME}"
                        '''
                    }
        }
        stage('build') {
            steps {
                sh 'mvn --version'
                sh 'mvn -Dmaven.test.failure.ignore=true install'
                echo "Build Successful"
            }
            post {
                   success {
                       junit 'target/surefire-reports/**/*.xml'
                   }
            }
        }
    }
}
