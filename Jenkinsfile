#!groovy
@Library('jenkinsLib') _
currentBuild.displayName = "#${env.BUILD_NUMBER}-${branch_name}"
pipeline {
    agent { node { label 'build-slave' } }
    environment {
        rollback_on_failure = "true"
        port = ""
        protocol = ""
        channel = "#devops"
    }
    parameters {
        choice(
            choices: 'alpine-nginx-phpfpm-pgsql',
            description: 'set the target service for deployment',
            name: 'service')
        string(
            defaultValue: "",
            description: 'Image tag or version number need to provide for build and push to docker registry',
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
                    env.deploy_tag = params.version == '' ? null : params.service

                    echo "DEBUG: env.service: ${env.service}"
                    echo "DEBUG: env.deploy_tag: ${env.deploy_tag}"

                    
                }
            }
        }
        stage('build') {
            when { expression { env.service == "clair"} } //build phase only valid for certain services
            steps {
                script {
                    dir ("${env.service}/docker") {
                        sh "docker build . -t ccctechcenter/${env.service}:latest"
                        ceBuild.dockerPush("ccctechcenter/${env.service}", env.deploy_tag)
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
