#! /usr/bin/env sh

DOCKER_IMAGE=ubuntu-riscv-env

docker run -it --rm --name rv32-env $DOCKER_IMAGE /bin/bash
