pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'my-cd-app:latest'
        CONTAINER_NAME = 'my-cd-app-container'
    }
    
    stages {
        stage('Check Environment') {
            steps {
                script {
                    // Проверяем доступность Docker
                    sh '''
                        echo "Checking Docker availability..."
                        docker --version || echo "Docker not available"
                        docker ps || echo "Cannot connect to Docker daemon"
                    '''
                }
            }
        }
        
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    // Проверяем доступность Docker перед сборкой
                    def dockerAvailable = sh(script: 'which docker || echo "not-found"', returnStdout: true).trim()
                    if (dockerAvailable == "not-found") {
                        error "Docker is not available in the Jenkins environment"
                    }
                    
                    // Собираем образ
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        
        stage('Stop Old Container') {
            steps {
                script {
                    echo "Stopping previous container..."
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"
                }
            }
        }
        
        stage('Deploy New Container') {
            steps {
                script {
                    echo "Deploying new container..."
                    sh "docker run -d --name ${CONTAINER_NAME} -p 3000:80 ${DOCKER_IMAGE}"
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    echo "Verifying deployment..."
                    sleep 10
                    sh "curl -f http://localhost:3000 || exit 1"
                }
            }
        }
    }
    
    post {
        always {
            echo "Pipeline execution completed"
        }
        success {
            echo "✅ Application deployed successfully!"
            echo "🌐 Access your app at: http://localhost:3000"
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}
