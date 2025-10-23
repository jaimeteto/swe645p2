pipeline {
  agent any
  options { timestamps() }
  environment {
    IMAGE_REPO = "jaimeteto/studentsurvey645"   // no tag here
    VERSION    = "0.1"                          // version string
    TS         = sh(script: "date +%Y%m%d-%H%M%S", returnStdout: true).trim()
  }

  stages {
    stage('Checkout') {
      steps { checkout scm } // safe even if job is “Pipeline script from SCM”
    }

    stage('Build Docker image') {
      steps {
        sh '''
          echo "Repo: ${IMAGE_REPO}"
          echo "Version: ${VERSION}"
          echo "Timestamp: ${TS}"

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
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub',
          usernameVariable: 'DHU',
          passwordVariable: 'DHP'
        )]) {
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

    stage('Deploy to Kubernetes') {
      steps {
        sh '''
          NS=default
          DEPLOY=student-survey
          CONTAINER=container-0
          NEW_IMAGE=${IMAGE_REPO}:${VERSION}-${TS}

          echo "Updating $DEPLOY/$CONTAINER to $NEW_IMAGE ..."
          kubectl -n $NS set image deployment/$DEPLOY $CONTAINER=$NEW_IMAGE
          kubectl -n $NS rollout status deployment/$DEPLOY --timeout=180s
          echo "Deployment updated successfully."
        '''
      }
    }
  }
}
