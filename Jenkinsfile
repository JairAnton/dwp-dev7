@Library("workflowlibs") _

pipeline {
  agent any
  stages {
    stage('Checkout Global Library') {
      steps {
        script {
          globalBootstrap {
            libraryName = 'Ether.Salesforce'
            libraryBranch = 'latest'
            entrypointParams = [:]
          }
        }
      }
    }
  }
}
