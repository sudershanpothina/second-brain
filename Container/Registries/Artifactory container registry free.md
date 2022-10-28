```
docker pull docker.bintray.io/jfrog/artifactory-jcr:latest
docker run --name artifactory -d -p 8081:8081 -p 8082:8082 docker.bintray.io/jfrog/artifactory-jcr:latest
```
#artifactory

Default credentials
	user: admin
	password: password
More info 
https://www.jfrog.com/confluence/display/JCR6X/Installing+with+Docker#InstallingwithDocker-Step1:PullingtheJFrogContainerRegistryDockerImage

