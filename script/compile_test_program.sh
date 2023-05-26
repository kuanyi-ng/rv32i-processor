#!/bin/sh

ROOT_DIR=$(pwd)

# move to respective directory
cd "$1" || exit

# compile
make OPTIMIZE=3

# move back to start directory
cd "$ROOT_DIR" || exit
