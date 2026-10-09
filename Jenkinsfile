
pipeline {
    agent any

    environment {
        IMAGE_NAME = 'ghcr.io/shanjunethra/pep-devops-app:1.0'
        EC2_HOST = '13.203.219.6'
        EC2_USER = 'ubuntu'
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

        stage('Deploy to EC2') {
            steps {
                sshagent(credentials: ['ec2-ssh-key']) {
                    bat '''
                        @echo off
                        ssh -o StrictHostKeyChecking=accept-new %EC2_USER%@%EC2_HOST% "sudo docker pull %IMAGE_NAME% && sudo docker rm -f pep-devops-web || true"
                        if errorlevel 1 exit /b 1

                        ssh %EC2_USER%@%EC2_HOST% "sudo docker run -d --restart unless-stopped --name pep-devops-web -p 80:80 %IMAGE_NAME%"
                        if errorlevel 1 exit /b 1
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Build, push, and EC2 deployment completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the Console Output for the failing stage.'
        }
        always {
            echo 'Jenkins pipeline finished.'
        }
    }
}