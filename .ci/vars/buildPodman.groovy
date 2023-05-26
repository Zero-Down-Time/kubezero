// Common container builder by ZeroDownTime

def call(Map config=[:]) {
    pipeline {
      agent {
        node {
          label 'podman-aws-trivy'
        }
      }
      stages {
        stage('Prepare') {
          steps {
            // pull tags
            withCredentials([gitUsernamePassword(credentialsId: 'gitea-jenkins-user')]) {
              sh 'git fetch -q --tags ${GIT_URL}'
            }
            sh 'make prepare || true'
          }
        }

        // Build using rootless podman
        stage('Build') {
          steps {
            sh 'make build'
          }
        }

        stage('Test') {
          steps {
            sh 'make test'
          }
        }

        // Scan via trivy
        stage('Scan') {
          environment {
            TRIVY_FORMAT = "template"
            TRIVY_OUTPUT = "reports/trivy.html"
          }
          steps {
            sh 'mkdir -p reports && make scan'
            publishHTML target: [
              allowMissing: true,
              alwaysLinkToLastBuild: true,
              keepAll: true,
              reportDir: 'reports',
              reportFiles: 'trivy.html',
              reportName: 'TrivyScan',
              reportTitles: 'TrivyScan'
            ]

            // Scan again and fail on CRITICAL vulns, if not overridden
            script {
              if (config.trivyFail == 'NONE') {
                echo 'trivyFail == NONE, review Trivy report manually. Proceeding ...'
              } else {
                sh "TRIVY_EXIT_CODE=1 TRIVY_SEVERITY=${config.trivyFail} make scan"
              }
            }
          }
        }

        // Push to container registry, skip if PR
        stage('Push') {
          when { not { changeRequest() } }
          steps {
            sh 'make push'
          }
        }

      }
    }
  }
