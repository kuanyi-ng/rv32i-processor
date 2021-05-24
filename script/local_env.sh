#! /usr/bin/env sh

DOCKER_IMAGE=ubuntu-riscv-env

# Build Docker Image
docker build . -t $DOCKER_IMAGE:latest

# Enter Docker Container
docker run -it --rm --name rv32-env $DOCKER_IMAGE /bin/bash
