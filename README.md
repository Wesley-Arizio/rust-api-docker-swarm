## Rust API

I've built this project to learn how to deploy an application using docker. \
Using rocket, I created a API that returns only "hello world"

### Steps to deploy

1. I created the API that returns ```Hello world``` in the default endpoint.
2. Then I wrote a ```Dockerfile``` to create an image to deploy the app:
   *  Using docker multi-stages feature, I used  the ```rust:bullseye``` base image to build a release version of the project
   *  Then, I used ```debian:bullseye-slim``` as a base image to start the app, only using the executable file of the project.
3. I pushed the image to dockerhub using ```docker push <docker_hub_name>/<image_name>:<tag>```
4. After that I needed to configure 5 vm's in aws ec2 services (2 managers and 3 workers).
   * To configure the vm's and download the certificate access [aws documentation](https://aws.amazon.com/pt/ec2/features/)
   * Then, using ssh to access the 5 vm's
     * I created the swarm using the command ```docker swarm init --advertise-addr <manager_public_ip_addess>```
     * Once the swarm was created, I was able to add workers and managers using the command ```docker swarm join --token <worker_or_manager_token> <first_manager_public_ip_address>```
     * Changed the availability of the managers to ```drain``` using the command ```docker node update --availability drain <node_id>``` so they can't have any containers and only manage workers.
     * To deploy the app, I used the ```docker-compose.yaml``` from this repository in one of the managers
     * Using this command ```docker stack deploy --compose-file docker-compose.yaml <service_name>``` I deployed the app.