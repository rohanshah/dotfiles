### Docker Containers
Publish port `80` in container with the following line in the image's `Dockerfile`:
```
...
EXPOSE 80
...
```
Run container with your machine port `4000` mapped to the container’s published port `80`:
```
docker run -p 4000:80 ...
```
Run container in detached mode:
```
docker run -d ...
```
List Running Containers
```
docker container ls
```
Stop Container
```
docker container stop 1fa4ab2cf395
```

### Docker Services

### Docker Compose
