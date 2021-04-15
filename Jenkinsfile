pipeline { 
    environment { 
        registry = "jpolara2016/test_app" 
        registryCredential = 'dockerhub_id' 
        dockerImage = '' 
    }
    agent any 
    stages {
        stage('Cloning Git') { 
            steps { 
                git 'https://github.com/jpolara2016/test_app' 
            }
        } 
        stage('Building image') { 
            steps { 
                script { 
                    dockerImage = docker.build registry + ":latest" 
                }
            } 
        }
        stage('Deploy image') { 
            steps { 
                script { 
                    docker.withRegistry( '', registryCredential ) { 
                        dockerImage.push() 
                    }
                } 
            }
        } 
        stage('Cleaning up') { 
            steps { 
                sh "docker rmi $registry:latest" 
            }
        }
        stage('Updating Cluster Definition') { 
            steps { 
                sh '''
                app_name="test-app"
                region="us-east-1"
                cluster_name=`aws ecs list-clusters | grep $app_name | awk -F "/" '{ print $2 }' | sed 's/"//'`
                ecs_service_name=`aws ecs list-services --cluster $cluster_name | awk -F "/" '{ print $3 }' | sed 's/"//' | sed '/^$/d'`
                task_definition_name=`aws ecs list-task-definitions | grep $app_name | awk -F: '{ print $6 }' | awk -F "/" '{ print $2 }'`
                desired_count=`aws ecs describe-services --cluster $cluster_name --services $ecs_service_name | grep desiredCount | tail -n 1 | awk -F ": " '{ print $2 }' | sed 's/,//'`
                aws ecs --region $region update-service --cluster $cluster_name --service $ecs_service_name --task-definition $task_definition_name --desired-count $desired_count --force-new-deployment
                '''
            }
        }
    }
}
