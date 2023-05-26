# shell

ROOT_DIR=$(pwd)

cd test_ground/ || exit

TRUE="\$True"

if [[ $1 == "$TRUE" ]]; then
    xmverilog -s +access+rwc +gui top_test.v +tcl+shm_gui.tcl
else
    xmverilog -s +access+rwc top_test.v +tcl+shm.tcl
fi

cd "$ROOT_DIR" || exit
