https://hub.docker.com/r/sonatype/nexus3/
#nexus


```
docker run -d -p 8081:8081 -p 8082 --name nexus sonatype/nexus3

# persist data
docker run -d -p 8081:8081 --name nexus -v nexus-data:/nexus-data sonatype/nexus3
```

User: admin
password at /nexus-data/admin.password

![](https://i.imgur.com/LGJ5URW.png)

![](https://i.imgur.com/mduVBRx.png)


![](https://i.imgur.com/a6B3FOP.png)
