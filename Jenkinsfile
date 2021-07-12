node {
    def server = '192.168.0.13:8082/docker-virtual'
    def imageName = 'spring-petclinic-2.4.6'
    def imageVersion = '2a1c34'
    def dockerImage = ''
//     environment {
//         registryCredentialSet = 'artifact-pwd'
//     }
    stage('Mvn Package') {
                def mvnHome = tool name: 'maven-3', type: 'maven'
                def mvnCMD = "${mvnHome}/bin/mvn"
                sh "${mvnCMD} clean package"
    }
//     stage('Build Docker Image') {
//             echo "....Docker Build Started...."
//             // This is DockerHub Build
//             //sh 'docker build -t avinash04/my-docker:spring-petclinic-2.4.6 .'
//             //sh "docker build -t ${server}/${imageName}:${imageVersion} ."
//             dockerImage = docker.build ${server} + "${imageName}:${imageVersion}"
//     }

    //stage('Push Docker Image') {
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

//             docker.withRegistry(${server}, registryCredentialSet){
//                 //sh "docker push ${server}/${imageName}:${imageVersion}"
//                 dockerImage.push()
//             }
//     }

//     stage('publish docker') {
//             withCredentials([usernamePassword(credentialsId: 'jfrog-artifact', passwordVariable: 'DOCKER_REGISTRY_PWD', usernameVariable: 'DOCKER_REGISTRY_USER')]) {
//                 // assumes Jib is configured to use the environment variables
//                 sh 'docker login ${server}'
//                 sh "docker push ${server}/${imageName}:${imageVersion}"
//             }
//     }

    stage('Build Docker image') {
            /*builds the image; synonymous to Docker build on the command line */
            app = docker.build("${server}")
        }
        stage('Test Docker image') {
            app.inside {
                sh 'echo "Tests passed"'
            }
        }
        stage('Push Docker image') {
            /* Finally, we'll push the image with two tags:
             * First, the incremental build number from Jenkins
             * Second, the 'latest' tag.
             * Pushing multiple tags is cheap, as all the layers are reused. */
            docker.withRegistry('${server}', 'jfrog-artifact') {
                app.push("${imageName}")
                app.push("${imageVersion}")
            }
        }
        stage('Send slack notification') {
             slackSend color: 'good', message: 'Message from Jenkins Pipeline'
        }
}
