```
 
docker-compose.yml
---  
version: '2'  
services:  
  broker:  
    image: bashj79/kafka-kraft  
    hostname: broker  
    container_name: broker  
    ports:  
      - "9092:9092"  
    environment:  
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://broker:9092  
  
  control-center:  
    image: confluentinc/cp-enterprise-control-center:7.2.1  
    hostname: control-center  
    container_name: control-center  
    depends_on:  
      - broker  
    ports:  
      - "9021:9021"  
    environment:  
      CONTROL_CENTER_BOOTSTRAP_SERVERS: 'broker:9092'  
      CONTROL_CENTER_REPLICATION_FACTOR: 1  
      CONTROL_CENTER_INTERNAL_TOPICS_PARTITIONS: 1  
      CONTROL_CENTER_MONITORING_INTERCEPTOR_TOPIC_PARTITIONS: 1  
      CONFLUENT_METRICS_TOPIC_REPLICATION: 1  
      PORT: 9021
```
#kafka-installation 
