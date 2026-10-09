
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'GitHub repository connected!'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t pep-devops-app:1.0 ./app'
            }
        }

        stage('Verify Docker Image') {
            steps {
                bat 'docker images pep-devops-app'
            }
        }
    }
}