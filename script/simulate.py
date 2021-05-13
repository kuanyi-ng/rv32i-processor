# python3

import subprocess

# List of test_program and their paths
test_programs_paths = {
    "bitcnts": "./test_pack/MiBench/bitcnts/test/",
    "dijkstra": "./test_pack/MiBench/dijkstra/test/",
    "dijkstra_2": "./test_pack/MiBench/dijkstra/test2/",
    "stringsearch": "./test_pack/MiBench/stringsearch/test/",
    "hello": "./test_pack/c/hello/",
    "napier": "./test_pack/c/napier/test/",
    "pi": "./test_pack/c/pi/test/",
    "prime": "./test_pack/c/prime/test/",
    "babblesort": "./test_pack/c/sort/babble/test/",
    "insertsort": "./test_pack/c/sort/insert/test/",
    "quicksort": "./test_pack/c/sort/quick/test/",
    "load": "./test_pack/asm/load/",    # IN_TOTAL: 1000000
    "store": "./test_pack/asm/store/",  # IN_TOTAL: 1000000
    "load_use": "./test_pack/asm/load_use/",
    "p2": "./test_pack/asm/p2/",
    "p2_part": "./test_pack/asm/p2_part/",
}

def clean_test_ground():
    clean_command = f"sh script/clean_test_ground.sh".split()
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

def run_simulation(with_gui: bool = False):
    simulation_command = f"sh script/run_simulation.sh ${with_gui}".split()
    print("running simulation")
    subprocess.run(simulation_command)

if __name__ == "__main__":
    import sys
    if len(sys.argv) <= 1:
        print('ERORR: no test program provided')
        print(f'test programs available: {list(test_programs_paths.keys())}')
        sys.exit(1)

    test_program = sys.argv[1]
    with_gui = (sys.argv[2] == 'gui') if (len(sys.argv) >= 3) else False

    # clean up test_ground/ (except tcl file)
    clean_test_ground()

    # copy src/ to test_ground/
    copy_src_to_test_ground()

    # compile test program (also clean previous make)
    compile_test_program(test_program=test_program)

    # cp test program (Imem.dat and Dmem.dat) to test_ground/
    copy_test_program_to_test_ground(test_program=test_program)

    # run simulation
    run_simulation(with_gui=with_gui)