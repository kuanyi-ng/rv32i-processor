# python3
from utils import (
    files_in_path,
    select_verilog_files
)
import subprocess

# List of test_program and their paths
test_programs_paths = {
    "bitcnts": "./test_pack/MiBench/bitcnts/test/",
    "dijkstra": "./test_pack/MiBench/dijkstra/test/",
    "stringsearch": "./test_pack/MiBench/stringsearch/test/",
    "hello": "./test_pack/c/hello/",
    "napier": "./test_pack/c/napier/",
    "pi": "./test_pack/c/pi/",
    "prime": "./test_pack/c/prime/",
    "skel": "./test_pack/c/skel/",
    "sort": "./test_pack/c/sort/",
    "load": "./test_pack/asm/load/",    # IN_TOTAL: 1000000
    "store": "./test_pack/asm/store/",  # IN_TOTAL: 1000000
    "load_use": "./test_pack/asm/load_use/",
    "p2": "./test_pack/asm/p2/",
}

def clean_test_ground():
    files_in_test_ground = files_in_path(path='./test_ground')
    files_to_delete = select_verilog_files(filenames=files_in_test_ground)
    print(f"files to delete in test_ground/: {files_to_delete}")

    clean_command = f"rm {' '.join(files_to_delete)}".split()
    print("removing verilog files from test_ground/")
    subprocess.run(clean_command)

def copy_src_to_test_ground():
    copy_command = "sh script/cp_from_src_to_test_ground.sh".split()
    print("copying verilog files from src/ to test_ground/")
    subprocess.run(copy_command)

def compile_test_program(test_program: str):
    path_to_test_program = test_programs_paths[test_program]
    compile_command = f"sh script/compile_test_program.sh {path_to_test_program}".split()
    print("compiling test program")
    subprocess.run(compile_command)

def copy_test_program_to_test_ground(test_program: str):
    path_to_test_program = test_programs_paths[test_program]
    copy_command = f"sh script/cp_test_program_to_test_ground.sh {path_to_test_program}".split()
    print("copying Imem and Dmem of test program to test_ground/")
    subprocess.run(copy_command)

def run_simulation():
    simulation_command = f"sh script/run_simulation.sh".split()
    print("running simulation")
    subprocess.run(simulation_command)

if __name__ == "__main__":
    import sys
    if len(sys.argv) <= 1:
        print('ERORR: no test program provided')
        print(f'test programs available: {list(test_programs_paths.keys())}')
        sys.exit(1)

    test_program = sys.argv[1]

    # clean up test_ground/ (except tcl file)
    clean_test_ground()

    # copy src/ to test_ground/
    copy_src_to_test_ground()

    # compile test program (also clean previous make)
    compile_test_program(test_program=test_program)

    # cp test program (Imem.dat and Dmem.dat) to test_ground/
    copy_test_program_to_test_ground(test_program=test_program)

    # run simulation
    run_simulation()