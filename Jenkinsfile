pipeline {
     agent any
    triggers {
        pollSCM '* * * * *'
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                sh '''Building
                '''
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
                sh '''Testing
                '''
            }
        }
        stage('Deliver') {
            steps {
                echo 'Deliver....'
                sh '''
                echo 'doing delivery stuff..'
                '''
            }
        }
    }
}