#!/bin/sh

ROOT_DIR=$(pwd)

# cp Imem.dat and Dmem.dat to test_ground
cp $1*.dat test_ground/

cd $1

make clean

cd "$ROOT_DIR" || exit
