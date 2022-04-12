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
            sh 'ng build --prod --aot --sm --progress=false' 
          } 
       }

 stage('Deploy Stage') {
    steps {
            cloudFoundryDeploy(
                    script: this,
                    deployType: 'standard',
                    deployTool: 'cf_native',
                    cloudFoundry: [apiEndpoint: 'https://api.cf.us10.hana.ondemand.com/', appName: 'angularProject', manifest: './manifest.yml', org: '9648b7fatrial', space: 'dev', credentialsId: 'tesnim']
                      )
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

