pipeline {
    agent any
    environment {
        FLUTTER_HOME = 'C:/flutter'
        PATH = "$FLUTTER_HOME/bin;C:/Program Files/Git/bin;$PATH"
    }
    stages {
        stage('Verify PATH') {
            steps {
                bat 'echo %PATH%'
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/luckyjayagroup/leontech02.git'
            }
        }
        stage('Verify Git') {
            steps {
                bat 'git --version'
            }
        }
        stage('BUILD') {
            steps {
                sh '''
                  #!/bin/sh
                  flutter build apk --debug
                  '''
            }
        }
        stage('Install Dependencies') {
            steps {
                bat 'flutter pub get'
            }
        }
        stage('Analyze') {
            steps {
                bat 'flutter analyze'
            }
        }
        stage('Test') {
            steps {
                bat 'flutter test'
            }
        }
        stage('Build APK') {
            steps {
                bat 'flutter build apk --release'
            }
        }
    }
}
