#!groovy
@Library('jenkinsLib') _
currentBuild.displayName = "#${env.BUILD_NUMBER}-${branch_name}"
pipeline {
    agent { node { label 'build-slave' } }
    environment {
        rollback_on_failure = "true"
        port = ""
        protocol = ""
        environment = "alpine"
        channel = "#devops"
    }
    parameters {
        choice(
            choices: 'alpine-nginx-phpfpm-pgsql',
            description: 'alpine-nginx-phpfpm-pgsql service for Build',
            name: 'service')
        string(
            defaultValue: "",
            description: 'Image version override from latest to custome version (optional - will tag with provided version and publish to docker registry, version tag format (X.Y.Z)',
            name: 'version')
    }
    options {
        buildDiscarder(logRotator(artifactDaysToKeepStr: '60', artifactNumToKeepStr: '10', daysToKeepStr: '60', numToKeepStr: '10'))
    }
    stages {
        stage('init') {
            steps {
                script {
                    env.service = params.service == '' ? null : params.service
                    env.deploy_tag = params.version == '' ? ceBuild.getDeployTag(env.service, env.BRANCH_NAME) : params.version 

                    echo "DEBUG: env.service: ${env.service}"
                    echo "DEBUG: env.deploy_tag: ${env.deploy_tag}"
                    echo "DEBUG: env.environment: ${env.environment}"

                    
                }
            }
        }
        stage('build') {
            when { expression { env.service == "alpine-nginx-phpfpm-pgsql"} } 
            steps {
                script {
                        sh "docker build . -t ccctechcenter/${env.service}:latest"
                        
                        ceBuild.dockerPush("ccctechcenter/${env.service}", env.deploy_tag)

                        ceBuild.imageScan(image: "ccctechcenter/${env.service}:${env.deploy_tag}", level: "High", channel: "#devops", ignore_failure: true) 

                }
            }
        }
    }
    post {
        failure {
            script {
                ceDeploy.slackNotify(env.channel, "danger", "Failure", env.service, env.environment, env.url, env.deploy_tag)
            }
        }
        success {
            script {
                ceDeploy.slackNotify(env.channel, "good", "Success", env.service, env.environment, env.url, env.deploy_tag)
            }
        }
    }
}

