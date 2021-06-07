#!/usr/bin/sh

cd test_ground/ || exit

# rm Verilog files, Dat files
ls | grep -v "shm.tcl\|shm_gui.tcl" | xargs rm -r

cd ../
