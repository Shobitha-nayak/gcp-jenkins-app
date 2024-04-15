pipeline {
    agent any

    environment {
        PROJECT_ID = 'multi-k8s-420306'
        CLUSTER_NAME = 'autopilot-cluster-1'
        CLUSTER_ZONE = 'asia-south1'
        DOCKER_IMAGE_TAG = 'latest'
        DOCKER_IMAGE_NAME = "gcr.io/${multi-k8s-420306}/myapp:${latest}"
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
                
                    sh 'cat $GOOGLE_APPLICATION_CREDENTIALS | docker login -u _json_key --password-stdin https://gcr.io/multi-k8s/myapp:latest'
                    sh "docker push ${DOCKER_IMAGE_NAME}"
                }
            }
        }

        stage('Deploy to GKE') {
            steps {
                withCredentials([file(credentialsId: 'GCPCredentials', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh "gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${CLUSTER_ZONE} --project ${PROJECT_ID}"
                    sh "kubectl apply -f ."
                }
            }
        }
    }
