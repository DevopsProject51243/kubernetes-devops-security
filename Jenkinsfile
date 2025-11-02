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
        }
        stage('Mutation Tests - PIT') {
            steps {
                sh 'mvn org.pitest:pitest-maven:mutationCoverage'
            }
            }


         stage('SonarQube - SAST') {
            steps {
                echo "Starting SonarQube Static Analysis..."
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                
                withSonarQubeEnv('SonarQube') {  // 'SonarQube' must match Jenkins global server config name
                    sh """ mvn clean verify sonar:sonar \ -Dsonar.projectKey=numeric \ -Dsonar.projectName='numeric' \ -Dsonar.host.url=http://43.205.233.114:9000 \ -Dsonar.token=sqp_7332b561f5b77c52398229eaadee969ca1ae48d9"""
                }
            }
            }



        // stage('SonarQube - SAST') {
        //     steps {
        //         withSonarQubeEnv('SonarQube') {
                    
        //         }
        //         timeout(time: 2, unit: 'MINUTES') {
        //             script {
        //                 waitForQualityGate abortPipeline: true
        //             }
        //         }
        //     }
        // }

        // stage('Vulnerability Scan - Docker') {
        //     steps {
        //         parallel {
        //             'Dependency Scan': { sh 'mvn dependency-check:check' },
        //             'Trivy Scan':        { sh 'bash trivy-docker-image-scan.sh' },
        //             'OPA Conftest': {
        //                 sh """
        //                 docker run --rm -v \$(pwd):/project \
        //                     openpolicyagent/conftest test \
        //                     --policy opa-docker-security.rego Dockerfile
        //                 """
        //             }
        //         }
        //     }
        // }

        stage('Docker Build and Push') {
            steps {
                withDockerRegistry(credentialsId: 'docker-hub', url: '') {
                    sh 'printenv'
                    sh 'docker build -t ganesh5124/helm-counter:"$GIT_COMMIT" .'
                    sh 'docker push ganesh5124/helm-counter:"$GIT_COMMIT"'
                }
            }
        }
         stage('Kubernetes Deployment - DEV') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig']) {
                sh 'sed -i "s#replace#ganesh5124/helm-counter:${GIT_COMMIT}#g" k8s_deployment_service.yaml'
                sh 'kubectl apply -f k8s_deployment_service.yaml'
                }
            }
    }
        // post {
        //     always {
        //         junit 'target/surefire-reports/*.xml'
        //         jacoco execPattern: 'target/jacoco.exec'
        //         pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
        //         dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
        //     }
        // }
    }
}