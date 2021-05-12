#!/bin/sh

# move to respective directory
cd $1

# compile
make OPTIMIZE=3

# move back to start directory
cd ~/sandbox/
