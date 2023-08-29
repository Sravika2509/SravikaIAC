pipeline {

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    } 
    environment {
        REMOTE_HOST = 'remote-host'  // Replace with the actual remote host address
        REMOTE_USER = 'remote-user'  // Replace with the actual remote user
        REMOTE_PORT = 22  // Replace with the actual remote SSH port if different
        SSH_CREDENTIALS = credentials('your_ssh_credentials_id')  // Replace with your Jenkins SSH credentials ID
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent any

    stages {
        stage('checkout') {
            steps {
                script {
                    dir("terraform") {
                        git "https://github.com/Sravika2509/SravikaIAC.git"
                    }
                }
            }
        }

        stage('Plan') {
            steps {
                sshScript remote: [
                    host: env.REMOTE_HOST,
                    user: env.REMOTE_USER,
                    port: env.REMOTE_PORT,
                    credentialsId: env.SSH_CREDENTIALS,
                ], script: '''
                    cd /path/to/terraform/
                    terraform init
                    terraform plan -out tfplan
                    terraform show -no-color tfplan > tfplan.txt
                '''
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }

            steps {
                script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps {
                sshScript remote: [
                    host: env.REMOTE_HOST,
                    user: env.REMOTE_USER,
                    port: env.REMOTE_PORT,
                    credentialsId: env.SSH_CREDENTIALS,
                ], script: '''
                    cd /path/to/terraform/
                    terraform apply -input=false tfplan
                '''
            }
        }
    }
}
