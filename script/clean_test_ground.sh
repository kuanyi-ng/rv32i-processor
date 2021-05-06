# shell

cd test_ground/

# remove directory
rm -r waves.shm/ xcelium.d/

# rm Verilog files, Dat files
ls | grep -v "shm.tcl" | xargs rm

cd ../
