@Library('piper-lib-os') _

node() {
   
    stage('Init') {
       cleanWs()
       checkout scm
       setupCommonPipelineEnvironment script:this
       
    }
    stage('Build Stage') {
       mavenExecute(
         script: this,
         goals: ['install']
      )
    }
 
    stage('Unit Tests Stage') {
       mavenExecute(
           script: this,
           goals: ['test']
           )
       testsPublishResults(
           script: this,
           jacoco: true
       )
    }
      
    stage('Integration Stage') {
      mavenExecuteIntegration script: this
    }

    stage('Nexus Upload Stage') {
        nexusUpload (
         script: this,
         url: 'artefact.focus.com.tn:8081',
         mavenRepository:'maven-snapshots',
         nexusCredentialsId:'nexus_manvenuser',
         format:'maven',
         globalSettingsFile:'.pipeline/global_settings.xml'
           )
    }
   
    stage('Deploy Stage') {
      deployType: 'standard'
      deployTool: 'cf_native'
      cloudFoundryDeploy(
         script: this,
         cloudFoundry: [apiEndpoint: 'https://api.cf.us10.hana.ondemand.com/', appName: 'wiemproject', manifest: './manifest.yml', org: '9648b7fatrial', space: 'dev', credentialsId: 'null']
        )
    }
   }
