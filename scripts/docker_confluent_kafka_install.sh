#!/bin/bash
#Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo apt-get update;
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release;
	
#Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings;
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

#Use the following command to set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null;
  
#default umask may be incorrectly configured, preventing detection of the repository public key file. Try granting read permission for the Docker public key file before updating the package index
sudo chmod a+r /etc/apt/keyrings/docker.gpg;

#Update the apt package index
sudo apt-get update;

#Install Docker Engine, containerd, and Docker Compose
sudo apt-get --yes --force-yes install docker-ce docker-ce-cli containerd.io docker-compose-plugin;
sudo apt --yes --force-yes install docker-compose;

#Get permissions to run docker commands on the VM
#The two commands below need to be run if the user does not have permission to use the docker command
#sudo groupadd docker;
sudo usermod -aG docker ${USER};



#Next a Kafka broker will be setup
#In /home/${USER}/docker-compose.yml we have everything which needs to be run via Docker
#see https://developer.confluent.io/quickstart/kafka-docker/ for more info
#cd /home/${USER};
#docker-compose -f docker-compose.yml up -d;


#Verify that the services are up and running with below commands:
#docker compose ls
#docker container ls -a


echo "---
version: '3'
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:7.3.0
    container_name: zookeeper
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000

  broker:
    image: confluentinc/cp-kafka:7.3.0
    container_name: broker
    ports:
    # To learn about configuring Kafka for access across networks see
    # https://www.confluent.io/blog/kafka-client-cannot-connect-to-broker-on-aws-on-docker-etc/
      - "9092:9092"
    depends_on:
      - zookeeper
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: 'zookeeper:2181'
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_INTERNAL:PLAINTEXT
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092,PLAINTEXT_INTERNAL://broker:29092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1" > /home/${USER}/docker-compose.yaml

docker-compose -f docker-compose.yml up -d




