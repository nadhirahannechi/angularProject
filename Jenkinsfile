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
   }
}
