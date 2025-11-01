pipeline {
    agent any


    stages {
        stage('Build Artifact') {
            steps {
                // Compile and package without running tests
                sh "mvn clean package -DskipTests=true"
                // Archive the JAR for download
                archive 'target/*.jar'
            }
        }
    }
}
