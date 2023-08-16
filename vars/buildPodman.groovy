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
            // we set pull tags as project adv. options
            // pull tags
            //withCredentials([gitUsernamePassword(credentialsId: 'gitea-jenkins-user')]) {
            //  sh 'git fetch -q --tags ${GIT_URL}'
            //}
            // Optional project specific preparations
            sh 'make prepare'
          }
        }

        // Build using rootless podman
        stage('Build') {
          steps {
            sh 'make build GIT_BRANCH=$GIT_BRANCH'
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

        // Push to container registry if not PR
        // incl. basic registry retention removing any untagged images
        stage('Push') {
          when { not { changeRequest() } }
          steps {
            sh 'make push'
            sh 'make rm-remote-untagged'
          }
        }

        // generic clean
        stage('cleanup') {
          steps {
            sh 'make clean'
          }
        }
      }
    }
  }
