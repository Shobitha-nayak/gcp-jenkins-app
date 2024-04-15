pipeline {
    agent any
    
    environment {
        IMAGE_NAME = 'gcr.io/multi-k8s-420306/myapp'
        TAG = 'latest'
        PROJECT_ID = 'multi-k8s-420306'
    }
    
    stages {
        stage('Authenticate Docker') {
            steps {
                sh 'gcloud auth configure-docker'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $IMAGE_NAME:$TAG ."
                }
            }
        }
        
        stage('Push to Container Registry') {
            steps {
                script {
                    sh "docker tag $IMAGE_NAME:$TAG gcr.io/$PROJECT_ID/$IMAGE_NAME:$TAG"
                    sh "docker push gcr.io/$PROJECT_ID/$IMAGE_NAME:$TAG"
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "kubectl apply -f deployment.yaml"
                    sh "kubectl apply -f service.yaml"
                }
            }
        }
    }
}
