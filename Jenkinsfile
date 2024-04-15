pipeline {
    agent any
    environment {
        PROJECT_ID = 'multi-k8s-420306'
        CLUSTER_NAME = 'autopilot-cluster-1'
        LOCATION = 'asia-south1'
        CREDENTIALS_ID = 'multi-k8s'
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
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerID') {
                            myapp.push("latest")
                            myapp.push("${env.BUILD_ID}")
                    }
                }
            }
        }        
        stage('Deploy to GKE') {
            steps{
                sh "sed -i 's/hello:latest/hello:${env.BUILD_ID}/g' deployment.yaml"
                step([$class: 'KubernetesEngineBuilder', projectId: env.multi-k8s-420306, clusterName: env.autopilot-cluster-1, location: env.asia-south1, manifestPattern: 'deployment.yaml', credentialsId: env.multi-k8s, verifyDeployments: true])
            }
        }
    }    
}
