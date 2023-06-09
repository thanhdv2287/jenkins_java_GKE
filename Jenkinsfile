pipeline {
    agent any
    tools {
        maven 'maven'
    }
    environment {
        ArtifactId = readMavenPom().getArtifactId()
        Version = readMavenPom().getVersion()
        GroupId = readMavenPom().getGroupId()
        Name = readMavenPom().getName()
        dockerimagename = "nexus.vnext.vn:8082/tomcat"
        dockerImage = ""
    PROJECT_ID = 'thanhdv-lap'
    CLUSTER_NAME = 'cluster-2'
    LOCATION = 'us-central1-b'
    CREDENTIALS_ID = 'thanhdv-lap'
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean install package'
            }
        }
        stage("Code Review with SonaQube") {
            agent any
            steps {
              withSonarQubeEnv('Sonar-Qube') {
                sh 'mvn clean package sonar:sonar'
              }
            }
          }
        stage('Publish to Nexus') {
            steps { 
                script {
                    def NexusRepo = Version.endsWith("SNAPSHOT") ? "MyLab-SNAPSHOT" : "MyLab-RELEASE"
                    
                    nexusArtifactUploader artifacts: 
                    [
                        [
                            artifactId: "${ArtifactId}", 
                            classifier: '', 
                            file: "target/${ArtifactId}-${Version}.war", 
                            type: 'war'
                        ]
                    ], 
                    credentialsId: 'nexus', 
                    groupId: "${GroupId}", 
                    nexusUrl: 'nexus.vnext.vn', 
                    nexusVersion: 'nexus3', 
                    protocol: 'http', 
                    repository: "${NexusRepo}", 
                    version: "${Version}"
                }
            }
        }
        
        stage('Print Environment variables') {
            steps {
                echo "Artifact ID is '${ArtifactId}'"
                echo "Group ID is '${GroupId}'"
                echo "Version is '${Version}'"
                echo "Name is '${Name}'"
                echo "https://nexus.vnext.vn/repository/MyLab-RELEASE/com/mylab/${ArtifactId}/${Version}/${ArtifactId}-${Version}.war"
            }
        }
        stage('Build image') {
      steps{
          sh '''#!/bin/bash
          curl -u admin:123456 -L "https://nexus.vnext.vn/repository/MyLab-RELEASE/com/mylab/${ArtifactId}/${Version}/${ArtifactId}-${Version}.war" -H "accept: application/json" --output /var/jenkins_home/workspace/Lap3/ROOT.war
                '''
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }
        stage('Pushing Image') {
      environment {
               registryCredential = 'dockerhublogin'
           }
      steps{
        script {
          docker.withRegistry( 'http://nexus.vnext.vn:8082', registryCredential ) {
            dockerImage.push()
              dockerImage.push("${Version}")
          }
        }
      }
    }
    stage('Deploying App to Kubernetes') {
      steps{
        sh "sed -i 's/latest/${Version}/g' deploymentservice.yml"
                step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deploymentservice.yml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
            }
    }
    }
}
