
pipeline { 
   agent { 
       docker { 
           image 'trion/ng-cli-karma:1.2.1' 
       } 
   } 

   stages { 
       stage('Checkout') { 
         agent any 
          steps { 
               deleteDir() 
               checkout scm 
          } 
       } 
       stage('NPM Install') { 
          steps { 
             sh ' echo ${env.BUILD_TIMESTAMP}'
             sh 'npm install' 
          } 
       } 
 
 stage('Test') { 
   parallel {
 stage('test1'){ 
    steps { 
         script { 
         withEnv(["CHROME_BIN=/usr/bin/chromium-browser"]) { 
            sh 'ng test --progress=false --watch false' 
          } 
       }
        junit '**/test-results.xml' 
      }
}
stage('test2'){
steps{
 sh 'echo "Hello World"'
}
}
}
    }
 
    stage('Build') { 
       steps { 
            sh 'ng build --prod --aot --sm --progress=false' 
          } 
       }
    stage('Archive') { 
       agent none 
       steps { 
           sh 'tar -cvzf dist.tar.gz --strip-components=1 dist' 
           archive 'dist.tar.gz' 
          } 
       } 
stage('Nexus Upload Stage') {
                  agent none
                    steps {

                            withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'nexus_manvenuser',usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                                   sh 'curl -v -u ${USERNAME}:${PASSWORD} --upload-file dist.tar.gz http://artefact.focus.com.tn:8081/repository/webbuild/com/focuscorp/release/dist-$BUILD_TIMESTAMP.tar.gz'
                             }
                          
                    }
                }

    stage('Deploy Stage') {
      steps { 
      sh 'ls -a'
      timeout(time: 200, unit: 'SECONDS') {
          dir('dist') {
          sh 'ls' 
          sh 'cp ../manifest.yml manifest.yml'
      
        }
      }
    }
   }
  }
}
   
