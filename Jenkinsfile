pipeline {

    agent any

    stages {

        stage ("Copy .terraformrc to home directory") {
            steps {
                sh '''
                    cp .terraformrc ~/
                    terraform -version
                '''
            }
        }

        stage ("Create AWS instances EC2") {
            steps {
                sh '''
                    terraform init
                    terraform plan
                    terraform apply --auto-approve
                    sleep 300
                    ansible-playbook certwork.yml
                '''
            }
        }

        stage ("Run ansible Roles for Build and Prod VM's") {
            steps {
                sh '''
                    ansible-playbook certwork.yml
                '''
            }
        }
    }
}