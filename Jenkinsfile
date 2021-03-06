node {
   def mvnHome
   def appimage
   stage('Preparation') { // for display purposes
      // Get some code from a GitHub repository
      git branch: 'main',
            url: 'https://github.com/sblin/spring-petclinic'
      // Get the Maven tool.
      // ** NOTE: This 'M3' Maven tool must be configured
      // **       in the global configuration.           
      mvnHome = tool 'maven3'
   }    
   stage('Build') {
        sh "${mvnHome}/bin/mvn clean package -DskipTests=true -Dcheckstyle.skip"
   }
   stage('Update K8s.yaml'){
       sh "sed -i.bak 's/{{BUILD_NUMBER}}/$BUILD_NUMBER/g' xl-as-code/artifacts/app.yaml && rm xl-as-code/artifacts/app.yaml.bak"
       sh "sed -i.bak 's/{{dockerhubuser}}/$dockerhubuser/g' xl-as-code/artifacts/app.yaml && rm xl-as-code/artifacts/app.yaml.bak"
   }
   stage('Build Docker Image') {
       appimage = docker.build("$dockerhubuser/petclinic:$BUILD_NUMBER")
   }
   stage('Push Image to Registry(dockerhub)') {
       docker.withRegistry("", "dockerhub_credentials") {
           appimage.push("$BUILD_NUMBER")
       }
   }
   stage('Publish'){
       sh "./xlw apply --xl-deploy-url http://localhost:4516 -f xl-as-code/container-demo.yaml --values BUILD_NUMBER=$BUILD_NUMBER"
   }
        
}
