pipeline {

    agent any

    parameters {
        string(name: "Username", description: "Username for your Docker Hub")
        password(name: "Password", description: "Password for your Docker Hub")
    }

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

        stage ("Terraform Apply -> Create AWS instances x2") {
            steps {
                sh '''
                    terraform apply --auto-approve
                    sleep 30
                '''
            }
        }

        stage ("Create Docker Properties file, for use to login into docker hub") {
            steps {
                sh '''
                    echo "Username=$Username\nPassword=$Password\n" > dockercreds.properties
                '''
            }
        }

        stage ("Run ansible Roles for Build and Prod VM's") {
            steps {
                sh '''
                    ansible-playbook --user=ubuntu certwork.yml
                    sleep 180
                '''
            }
        }

        stage ("Terraform destroy --auto-approve") {
            steps {
                sh '''
                    terraform destroy --auto-approve
                '''
            }
        }
    }
}