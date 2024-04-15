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
                timeout(time: 3, unit: 'MINUTES') {
                    script {
                        myapp = docker.build("shobithaunayak24/hello:${env.BUILD_ID}")
                    }
                }
            }
        }

        stage("Push image") {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', dockerID) {
                        docker.image("shobithaunayak24/hello:${env.BUILD_ID}").push("latest")
                        docker.image("shobithaunayak24/hello:${env.BUILD_ID}").push()
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
