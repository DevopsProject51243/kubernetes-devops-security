pipeline {
    agent any


    stages {
        stage('Build - Maven') {
            steps {
                sh 'mvn clean package -DskipTests=true'
                archive 'target/*.jar'
            }
        }
        stage('Unit Tests & Coverage') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    // Publish JUnit results
                    junit 'target/surefire-reports/*.xml'
                    // Publish JaCoCo coverage
                    jacoco execPattern: 'target/jacoco.exec'
                }
            }
        }
        stage('Docker Build and Push') {
            steps {
                withDockerRegistry(credentialsId: 'docker-hub', url: '') {
                    sh 'printenv'
                    sh 'docker build -t ganesh5124/helm-counter:"$GIT_COMMIT" .'
                    sh 'docker push ganesh5124/helm-counter:"$GIT_COMMIT"'
                }
            }
        }
    }
}