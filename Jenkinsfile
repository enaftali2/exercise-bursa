@Library('my-shared-library@main') _  // Reference the shared library

pipeline {
    agent any

    environment {
        ARTIFACT_NAME = "my-app.jar"
        REPO_URL = "https://nexus.example.com/repository/maven-releases/"
        REPO_CREDENTIALS = "nexus-credentials"
    }

    stages {
        stage('SCM Checkout') {
            steps {
                script {
                    checkout scm  // Clones the repo
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
                    sh 'mvn clean package -DskipTests'  // Builds the Java artifact
                }
            }
        }

        stage('Package Artifact') {
            steps {
                script {
                    sh "mv target/*.jar ${ARTIFACT_NAME}"  // Rename and prepare the artifact
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
