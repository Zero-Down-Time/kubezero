// Common container builder by ZeroDownTime

def call(Map config=[:]) {
    pipeline {
      options {
        disableConcurrentBuilds()
      }
      agent {
        node {
          label 'podman-aws-trivy'
        }
      }
      stages {
        stage('Prepare') {
          steps {
            sh 'mkdir -p reports'

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
          steps {
            // we always scan and create the full json report
            sh 'TRIVY_FORMAT=json TRIVY_OUTPUT="reports/trivy.json" make scan'

            // render custom full html report
            sh 'trivy convert -f template -t @/home/jenkins/html.tpl -o reports/trivy.html reports/trivy.json'

            publishHTML target: [
              allowMissing: true,
              alwaysLinkToLastBuild: true,
              keepAll: true,
              reportDir: 'reports',
              reportFiles: 'trivy.html',
              reportName: 'TrivyScan',
              reportTitles: 'TrivyScan'
            ]
            sh 'echo "Trivy report at: $BUILD_URL/TrivyScan"'

            // fail build if issues found above trivy threshold
            script {
              if ( config.trivyFail ) {
                sh "TRIVY_SEVERITY=${config.trivyFail} trivy convert --report summary --exit-code 1 reports/trivy.json"
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
