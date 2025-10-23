pipeline {
  agent any
  environment {
    IMAGE_REPO = "jaimeteto/studentsurvey645"   // <-- NO tag here
    VERSION    = "0.1"                          // <-- just the version string
    TS         = sh(script: "date +%Y%m%d-%H%M%S", returnStdout: true).trim()
  }
  stages {
    stage('Build Docker image') {
      steps {
        sh '''
          echo "Repo: ${IMAGE_REPO}"
          echo "Version: ${VERSION}"
          echo "Timestamp: ${TS}"

          # Valid tags: only ONE colon each
          docker build \
            -t ${IMAGE_REPO}:${VERSION}-${TS} \
            -t ${IMAGE_REPO}:${VERSION} \
            -t ${IMAGE_REPO}:latest \
            .
        '''
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub',
                          usernameVariable: 'DHU', passwordVariable: 'DHP')]) {
          sh '''
            echo "$DHP" | docker login -u "$DHU" --password-stdin
            docker push ${IMAGE_REPO}:${VERSION}-${TS}
            docker push ${IMAGE_REPO}:${VERSION}
            docker push ${IMAGE_REPO}:latest
            docker logout || true
          '''
        }
      }
    }
  }
}
