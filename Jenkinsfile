def usernameVariable = 'mavenuser'
def passwordVariable = 'm@venp@$$word'
pipeline {
 agent {
        docker {
            image 'trion/ng-cli-karma:1.2.1' 
        }
    }
    
 options {
    buildDiscarder(logRotator(numToKeepStr: '30', artifactNumToKeepStr: '30'))
  }

    stages {    
      
         stage('Checkout') {
             agent any
             // disable to recycle workspace data to save time/bandwidth
             steps {
              deleteDir()
              checkout scm
            }
         }

          stage('NPM Install') {
              // silent warn messages
               steps {
                  sh 'npm install'
              
               }
          }

          stage('Test') {
               steps {
               script{
              withEnv(["CHROME_BIN=/usr/bin/chromium-browser"]) {
                sh 'ng test --progress=false --watch false'
              }
               }
              // add a reporter that creates JUnit XML reports
              junit '**/test-results.xml'
          }
          }

          stage('Lint') {
            steps {   // add a reporter that creates JUnit XML reports
              sh 'ng lint'
          }
          }

          stage('Build') {
              steps {
                    sh 'ng build --prod --aot --sm --progress=false'
              }
          }

        stage('Archive') {
            agent none
            // archive the build artifact
             steps {
            sh 'tar -cvzf dist.tar.gz --strip-components=1 dist'
            archive 'dist.tar.gz'
             }
        }
        stage('Nexus Upload Stage') {
          agent none 
              steps {
             withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'nexus_manvenuser',usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
              echo "user ${usernameVariable}"
              echo "password ${passwordVariable}"
              sh 'curl -v -u ${usernameVariable}:${passwordVariable} --upload-file dist.tar.gz http://artefact.focus.com.tn:8081/repository/webbuild/dist.tar.gz' 
              }
              }
         }
 

        stage('Deploy') {
            agent none
             steps {
            echo "Deploying..."
             }
        }
    }
  }
