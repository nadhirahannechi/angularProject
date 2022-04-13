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
               sh 'npm install' 
          } 
       } 
 
 stage('Test') { 
    steps { 
         script { 
         withEnv(["CHROME_BIN=/usr/bin/chromium-browser"]) { 
            sh 'ng test --progress=false --watch false' 
          } 
       }
        junit '**/test-results.xml' 
      }
    }
 
 stage('Build') { 
    steps { 
            sh 'ng build --prod' 
          } 
       }
 /*stage('Archive') { 
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
               sh 'curl -v -u ${USERNAME}:${PASSWORD} --upload-file dist.tar.gz http://artefact.focus.com.tn:8081/repository/webbuild/dist.tar.gz' 
    } 
   } 
   } */
       stage('deploy') {
    steps { 
       sh 'ls -a'
       timeout(time: 200, unit: 'SECONDS') {
          dir('dist'){
             sh 'ls'
       pushToCloudFoundry(
  target: 'https://api.cf.us10.hana.ondemand.com/',
  organization: '2b1f4fe8trial',
  cloudSpace: 'dev',
  credentialsId: 'nadhira'
)
          }
       }
         }
    
    
}

   }
}

