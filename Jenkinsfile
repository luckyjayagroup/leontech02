pipeline {
    agent any

        environment {
        FLUTTER_HOME = 'C:\\flutter'
        JAVA_HOME = 'C:\\Program Files\\Java\\jdk-20'
        PATH = "$FLUTTER_HOME\\bin;$FLUTTER_HOME\\tools\bin;C:\\Program Files\\Git\\cmd;C:\\Program Files\\Git\\cmd\\bin;$PATH"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/luckyjayagroup/leontech02.git'
            }
        }
        stage('de doctor') { 
            steps {
                sh "flutter doctor -v"
            }
        }
        stage('Install Dependencies') { 
            steps {
                sh "flutter pub get"
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
