pipeline{
    agent any 

     parameters {
        string(name: 'DOCKER_TAG', defaultValue: 'latest', description: 'Enter the Docker image tag')
        string(name: 'APP_NAME', defaultValue: 'go-web-app', description: 'enter the app name')
    }

    enviroment {
        img_name= "sriram789/${params.APP_NAME}:${params.DOCKER_TAG}"
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
                    sh 'docker build -t ${img_name} .'
                }

            }
        }

        stage("docker push") {
            steps {
                script {
                    sh 'docker push ${img_name}'
                }

            }
        }

        stage("Delete Image from local") {
            steps {
                script{
                    sh 'docker rmi ${img_name}'
                }

            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
        success {
            echo "Pipeline execution is successfully completed"
        }
    }
}
