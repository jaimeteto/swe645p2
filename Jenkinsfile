pipeline {
  agent any
  environment {
    IMAGE = "jaimeteto/studentsurvey645:0.1"
    TS    = sh(script: "date +%Y%m%d-%H%M%S", returnStdout: true).trim()
  }
  stages {
    stage('Checkout') { steps { checkout scm } }

    stage('Build Docker image') {
      steps {
        sh 'docker build -t ${IMAGE}:0.1-${TS} -t ${IMAGE}:latest .'
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub',
                                          usernameVariable: 'DHU',
                                          passwordVariable: 'DHP')]) {
          sh '''
            echo "$DHP" | docker login -u "$DHU" --password-stdin
            docker push ${IMAGE}:${TS}
            docker push ${IMAGE}:latest
            docker logout || true
          '''
        }
      }
    }

    stage('Verify push') {
      steps { sh 'docker pull ${IMAGE}:${TS}' }
    }
  }
}
