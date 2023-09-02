# Production

## How to launch system

Build production docker image
```bash
docker build -t nm/nm_web_server -f build/Dockerfile.alpine.prod .
```

Run production docker container
```bash
docker run -p 4201:80 nm/nm_web_server
```
