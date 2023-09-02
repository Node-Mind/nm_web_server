#!/bin/bash

docker build -t nm/nm_web_server -f build/Dockerfile.alpine.prod .

docker run -p 4201:80 nm/nm_web_server

# Documentation: nm_web_server/build/README.md
