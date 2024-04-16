pipeline {
    agent any

    environment {
        PROJECT_ID = 'multi-k8s-420306'
        CLUSTER_NAME = 'autopilot-cluster-1'
        LOCATION = 'asia-south1'
        DOCKER_IMAGE_TAG = 'latest'
        DOCKER_IMAGE_NAME = "gcr.io/${PROJECT_ID}/myapp:${DOCKER_IMAGE_TAG}"
        CREDENTIALS_ID = 'gcpcredentials' // Assuming you have a credential ID set up in Jenkins
    }

    stages {
        stage('Copy Repository Contents') {
            steps {
                git branch: 'main', url: 'https://github.com/Shobitha-nayak/gcp-jenkins-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE_NAME} ."
            }
        }

        stage('Push Docker Image to GCR') {
            steps {
                withCredentials([file(credentialsId: 'gcpcredentials', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh 'cat $GOOGLE_APPLICATION_CREDENTIALS | docker login -u _json_key --password-stdin https://gcr.io'
                    sh "docker push ${DOCKER_IMAGE_NAME}"
                }
            }
        }

        stage('Deploy to GKE') {
            steps {
                withCredentials([file(credentialsId: 'gcpcredentials', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh "gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${LOCATION} --project ${PROJECT_ID}"
                    sh "kubectl apply -f deployment.yaml -f service.yaml"
                }
            }
        }
    }

    post {
        always {
            // Clean up any temporary resources if needed
            deleteDir()
        }
    }
}
