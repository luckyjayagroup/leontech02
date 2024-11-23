pipeline {
    agent any
    environment {
        FLUTTER_HOME = 'C:/flutter'
        PATH = "$FLUTTER_HOME/bin:$PATH;C:/Program Files/Git/bin"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/luckyjayagroup/baru.git'
            }
        }
        stage('Verify Git') {
            steps {
                bat 'git --version'
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
