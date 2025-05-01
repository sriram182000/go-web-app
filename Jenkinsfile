pipeline{
    agent any 

     parameters {
        string(name: 'DOCKER_TAG', defaultValue: 'latest', description: 'Enter the Docker image tag')
        string(name: 'APP_NAME', defaultValue: 'go-web-app', description: 'enter the app name')
    }



    stages {
        stage("docker login") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    }
                }
            }
        }

        stage("docker build") {
            steps {
                script{
                    sh 'docker build -t sriram789/${params.APP_NAME}:${params.DOCKER_TAG} .'
                }

            }
        }

        stage("docker push") {
            steps {
                script {
                    sh 'docker push sriram789/${params.APP_NAME}:${params.DOCKER_TAG}'
                }

            }
        }

        stage("Delete Image from local") {
            steps {
                script{
                    sh 'docker rmi sriram789/${params.APP_NAME}:${params.DOCKER_TAG}'
                }

            }
        }
    }
}

post {
    always {
        sh 'docker logout'
    }
}
