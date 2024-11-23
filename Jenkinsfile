pipeline {
    agent any

        environment {
        FLUTTER_HOME = 'C:/flutter'
        PATH = "$FLUTTER_HOME/bin;C:/Program Files/Git/bin;$PATH"
    }
 tools {
       flutter 'stable'  // Or your desired version - best practice to declare this
       jdk 'latest'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/luckyjayagroup/leontech02.git'
            }
        }
        stage('Install Dependencies') { 
            steps {
                sh 'flutter pub get' // Use sh directly now
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
