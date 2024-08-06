pipeline {
     agent any
    triggers {
        pollSCM '* * * * *'
    }
    stages {
        stage('Build') {
            steps {
              checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: '86e6a0d3-9b2d-488c-9cc7-ee54420958e5', url: 'https://github.com/jeyaram11/crm_sales_pipeline.git']])
            }
        }
    }
}