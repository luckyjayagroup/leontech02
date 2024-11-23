pipeline {
    agent any

        environment {
        FLUTTER_HOME = 'C:/flutter'
        PATH = "$FLUTTER_HOME/bin;C:/Program Files/Git/bin;$PATH"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/luckyjayagroup/leontech02.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                bat 'pubget.bat'
            }
        }
        stage('Analyze') {
            steps {
                sh 'flutter analyze'
            }
        }
        stage('Test') {
            steps {
                sh 'flutter test'
            }
        }
        stage('Build APK') {
            steps {
                sh 'flutter build apk --release'
            }
        }
    }
}
