pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'my-cd-app:latest'
        CONTAINER_NAME = 'my-cd-app-container'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }
        
        stage('Stop Old Container') {
            steps {
                script {
                    echo "Stopping previous container..."
                    sh 'docker stop ${CONTAINER_NAME} || true'
                    sh 'docker rm ${CONTAINER_NAME} || true'
                }
            }
        }
        
        stage('Deploy New Container') {
            steps {
                script {
                    echo "Deploying new container..."
                    docker.image("${DOCKER_IMAGE}").run(
                        "--name ${CONTAINER_NAME} -p 3000:80 -d"
                    )
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    echo "Verifying deployment..."
                    sleep 5
                    sh 'curl -f http://localhost:3000 || exit 1'
                }
            }
        }
    }
    
    post {
        always {
            echo "Pipeline execution completed"
            script {
                // Очистка старых образов
                sh 'docker image prune -f'
            }
        }
        success {
            echo "✅ Application deployed successfully!"
            echo "��� Access your app at: http://localhost:3000"
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}
