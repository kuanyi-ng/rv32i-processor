# shell

cd test_ground/

xmverilog -s +access+rwc top_test.v +tcl+shm.tcl
xmverilog -s +access+rwc +gui top_test.v +tcl+shm.tcl

cd ~/sandbox
