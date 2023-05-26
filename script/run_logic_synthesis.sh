#!/bin/usr/env bash

ROOT_DIR=$(pwd)

cd logic_synthesis_ground/ || exit

dc_shell-t -f logic_synthesis.tcl | tee log

cd "$ROOT_DIR" || exit
