pipeline {
    agent any
    environment {
        PROJECT_ID = 'multi-k8s-420306'
        CLUSTER_NAME = 'autopilot-cluster-1'
        LOCATION = 'asia-south1'
        CREDENTIALS_ID = 'multi-k8s'
        DOCKER_CREDENTIALS_ID = 'dockerID'
    }
    stages {
        stage("Checkout code") {
            steps {
                checkout scm
            }
        }
        stage("Build image") {
            steps {
                script {
                    myapp = docker.build("shobithaunayak24/hello:${env.BUILD_ID}")
                }
            }
        }
        stage("Push image") {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', dockerID) {
                        myapp.push("latest")
                        myapp.push("${env.BUILD_ID}")
                    }
                }
            }
        }        
        stage('Deploy to GKE') {
            steps{
                sh "sed -i 's/hello:latest/hello:${env.BUILD_ID}/g' deployment.yaml"
                step([$class: 'KubernetesEngineBuilder', projectId: PROJECT_ID, clusterName: CLUSTER_NAME, location: LOCATION, manifestPattern: 'deployment.yaml', credentialsId: CREDENTIALS_ID, verifyDeployments: true])
            }
        }
    }    
}
