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

        stage ("Terraform Init") {
            steps {
                sh '''
                    terraform init
                '''
            }
        }

        stage ("Terraform Plan") {
            steps {
                sh '''
                    terraform plan
                '''
            }
        }

        stage ("Terraform Apply (sleep 30s after)-> Create AWS instances EC2") {
            steps {
                sh '''
                    terraform apply --auto-approve
                    sleep 30
                '''
            }
        }

//         stage ("Create In-Memory-Inventory with ansible playbook") {
//             steps {
//                 sh '''
//                     ansible-playbook groupadd.yml
//                 '''
//             }
//
//         }

        stage ("Run ansible Roles for Build and Prod VM's") {
            steps {
                sh '''
                    ansible-playbook certwork.yml
                '''
            }
        }
    }
}