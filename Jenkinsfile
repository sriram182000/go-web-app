pipeline{
    agent any

     parameters {
        string(name: 'DOCKER_TAG', defaultValue: 'latest', description: 'Enter the Docker image tag')
        string(name: 'APP_NAME', defaultValue: 'go-web-app', description: 'enter the app name')
    }

    environment {
        img_name= "sriram789/${params.APP_NAME}:${params.DOCKER_TAG}"
        app_name= "${params.APP_NAME}"
        tag="${params.DOCKER_TAG}"
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
        stage("Update values.yaml to start CD"){
            steps {
                script{
                    sh "sed -i 's/tag: .*/tag: ${tag}/' helm/go-web-app-chart/values.yaml"
                    sh "sed -i 's/appName: .*/appName: ${app_name}/' helm/go-web-app-chart/values.yaml"
                }
           }
       }

       stage("Push changes to Repo") {
           steps {
               script {
                    withCredentials([usernamePassword(credentialsId: 'git_cred', passwordVariable: 'GIT_TOKEN', usernameVariable: 'GIT_USERNAME')]) {
                        sh """
                        git config user.email "saisriram13@gmail.com"
                        git config user.name "sriram182000"
                        https://${GIT_USERNAME}:${GIT_TOKEN}@github.com/${GIT_USERNAME}/${app_name}.git

                        git add helm/go-web-app-chart/values.yaml
                        git commit -m "Update appName and tag from Jenkins pipeline"
                        git push origin HEAD:main
                        """
                    }
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

