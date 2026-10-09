
pipeline {
    agent any

    environment {
        IMAGE_NAME = 'ghcr.io/shanjunethra/pep-devops-app:1.0'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'GitHub repository connected!'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %IMAGE_NAME% ./app'
            }
        }

        stage('Login to GHCR') {
            steps {
                withCredentials([string(
                    credentialsId: '5bf70357-1b34-45fa-8359-ebc9ab722c73',
                    variable: 'GHCR_TOKEN'
                )]) {
                    bat '''
                        @echo off
                        echo %GHCR_TOKEN% | docker login ghcr.io -u SHANJUNETHRA --password-stdin
                    '''
                }
            }
        }

        stage('Push Image to GHCR') {
            steps {
                bat 'docker push %IMAGE_NAME%'
            }
        }
    }

    post {
        always {
            echo 'Jenkins pipeline finished.'
        }
    }
}