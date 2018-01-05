### Docker Heirarchy

**Stack** - defines the interactions of all services
**Service** - defines how containers behave in production
**Container** / **Image** - defines the runtime environment of a single application

## Containers / Images

An **image** is a lightweight, stand-alone, executable package that includes
everything needed to run a piece of software, including the code, a runtime,
libraries, environment variables, and config files.

**Images** are defined by a `Dockerfile`

A **container** is a runtime instance of an image—what the image becomes in
memory when actually executed. It runs completely isolated from the host
environment by default, only accessing host files and ports if configured to do
so.

Containers run apps natively on the host machine’s kernel. They have better
performance characteristics than virtual machines that only get virtual access
to host resources through a hypervisor. Containers can get native access, each
one running in a discrete process, taking no more memory than any other executable.

Example `Dockerfile`:
```
# Use an official Python runtime as a parent image
FROM python:2.7-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Publish port 80 to make it available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
```

Build an image:
```
docker build -t [IMAGE TAG] [IMAGE DIRECTORY]
```

List images:
```
docker images
```

Run a container with your machine port `4000` mapped to the container’s published port `80`:
```
docker run -p 4000:80 ...
```

Run a container in detached mode:
```
docker run -d ...
```

List running containers and their associated IDs:
```
docker container ls
```

Stop a container:
```
docker container stop [CONTAINER ID]
```

## Services
**Services** are really just “containers in production.” A service only runs one
_image_. It codifies the way that image runs i.e. what ports it should use, how
many replicas of the container should run so the service has the capacity it
needs, and so on. Scaling a service changes the number of container instances
running that piece of software, assigning more computing resources to the service
in the process.

A single container running in a **service** is called a **task**.

**Services** are defined by a `docker-compose.yaml` file.

Example `docker-compose.yaml` file:
```
version: "3"
services:
  # defines a service named "web"
  web:
    # Which image to pull / use
    image: username/repo:tag
    deploy:
	  # Specifies the number of instances to run (5)
      replicas: 5
      resources:
        limits:
          # limits each instance to use, at most, 10% of the CPU (across all cores)
          cpus: "0.1"
          # limits each instance to use 50MB of RAM
          memory: 50M
      # immediately restart a container if it fails
      restart_policy:
        condition: on-failure
    # maps port 80 on the host to web’s port 80
    ports:
      - "80:80"
    # instruct web’s containers to share port 80 via a load-balanced network called "webnet"
    # internally, the containers themselves publish to web’s port 80 at an ephemeral port
    networks:
      - webnet
# define the "webnet" network with the default settings: a load-balanced overlay network
networks:
  webnet:
```

List Service IDs:
```
docker service ls
```

List Tasks for a Service:
```
docker service ps [SERVICE ID]
```

## Swarms
A **swarm** is a group of machines that are running Docker and joined into a cluster.

Docker commands are executed on an entire cluster by a **swarm manager**.

The machines in a swarm can be physical or virtual.

Machines in a swarm are referred to as **nodes**.

Make a node a swarm manager:
```
docker swarm init --advertise-addr [MACHINE IP]
```

Join a swarm as a worker node:
```
docker swarm join --token [SWARM TOKEN] [MANAGER IP]:[MANAGER PORT]
```

List nodes in a swarm:
```
docker node ls
```

Leave a swarm
```
docker swarm leave # from a worker node
docker swarm leave --force # from a manager node
```

## Stacks

A **stack** is a group of interrelated services that share dependencies, and can
be orchestrated and scaled together.

(Re-)Deploy a Stack:
```
docker stack deploy -c [DOCKER-COMPOSE FILE] [SERVICE]
```

Remove / Stop a Stack:
```
docker stack rm [SERVICE]
```
