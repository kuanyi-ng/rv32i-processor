# shell

cd test_ground/

xmverilog top_test.v
xmverilog -s +access+rwc top_test.v +tcl+shm.tcl

cd ~/sandbox