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
        
        stage('Build and Deploy on Host') {
            steps {
                script {
                    // Используем shell команды которые выполнятся на хосте
                    sh '''
                        echo "Building and deploying from Jenkins host..."
                        
                        # Переходим в рабочую директорию
                        cd /var/jenkins_home/workspace/my-cd-pipleline
                        
                        # Собираем Docker образ
                        docker build -t my-cd-app:latest .
                        
                        # Останавливаем старый контейнер
                        docker stop my-cd-app-container || true
                        docker rm my-cd-app-container || true
                        
                        # Запускаем новый контейнер
                        docker run -d --name my-cd-app-container -p 3000:80 my-cd-app:latest
                        
                        echo "Deployment completed!"
                        echo "Application available at: http://localhost:3000"
                    '''
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    sh '''
                        sleep 10
                        echo "Testing application..."
                        curl -f http://localhost:3000 && echo "✅ Application is running!" || echo "❌ Application failed to start"
                    '''
                }
            }
        }
    }
    
    post {
        always {
            echo "Pipeline execution completed"
        }
    }
}
