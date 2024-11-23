pipeline {
    agent any

    tools {
        flutter 'latest' // Or specify a version
        jdk 'latest' // Ensure a JDK is available, specify version as needed
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/luckyjayagroup/leontech02.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'flutter pub get' // Use sh for cross-platform compatibility
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
