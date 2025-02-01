@Library('my-shared-library@main') _  // Reference the shared library

pipeline {
    agent any

    environment {
        ARTIFACT_NAME = "my-app.jar"
        REPO_URL = "http://localhost:8081/repository/maven-releases/"
        REPO_CREDENTIALS = "nexus-credentials"
    }

    stages {
        stage('SCM Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Prepare Environment') {
            steps {
                script {
                    envVars = prepareEnv()
                    env.GIT_COMMIT = envVars['GIT_COMMIT']
                    env.GIT_BRANCH = envVars['GIT_BRANCH']
                    env.GIT_AUTHOR = envVars['GIT_AUTHOR']
                }
            }
        }

        stage('Build Artifact') {
            steps {
                script {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Package Artifact') {
            steps {
                script {
                    sh "mv target/*.jar ${ARTIFACT_NAME}"
                }
            }
        }

        stage('Upload to Repository') {
            steps {
                script {
                    sh """
                        curl -u ${REPO_CREDENTIALS} --upload-file ${ARTIFACT_NAME} ${REPO_URL}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully. Artifact uploaded!"
        }
        failure {
            echo "Pipeline failed. Please check the logs."
        }
    }
}
