# python3

import subprocess

# List of test_program and their paths
test_programs_paths = {
    "bitcnts": "./test_pack/MiBench/bitcnts/test/",
    "bitcnts_small": "./test_pack/MiBench/bitcnts/small/",
    "bitcnts_large": "./test_pack/MiBench/bitcnts/large/",
    "dijkstra": "./test_pack/MiBench/dijkstra/test/",
    "dijkstra_2": "./test_pack/MiBench/dijkstra/test2/",
    "dijkstra_small": "./test_pack/MiBench/dijkstra/small/",
    "dijkstra_large": "./test_pack/MiBench/dijkstra/large/",
    "stringsearch": "./test_pack/MiBench/stringsearch/test/",
    "stringsearch_small": "./test_pack/MiBench/stringsearch/small/",
    "stringsearch_large": "./test_pack/MiBench/stringsearch/large/",
    "hello": "./test_pack/c/hello/",
    "napier": "./test_pack/c/napier/test/",
    "napier_small": "./test_pack/c/napier/small/",
    "napier_mid": "./test_pack/c/napier/mid/",
    "napier_large": "./test_pack/c/napier/large/",
    "pi": "./test_pack/c/pi/test/",
    "pi_small": "./test_pack/c/pi/small/",
    "pi_mid": "./test_pack/c/pi/mid/",
    "pi_large": "./test_pack/c/pi/large/",
    "prime": "./test_pack/c/prime/test/",
    "prime_small": "./test_pack/c/prime/small/",
    "prime_mid": "./test_pack/c/prime/mid/",
    "prime_large": "./test_pack/c/prime/large/",
    "babblesort": "./test_pack/c/sort/babble/test/",
    "babblesort_small": "./test_pack/c/sort/babble/small/",
    "babblesort_mid": "./test_pack/c/sort/babble/mid/",
    "insertsort": "./test_pack/c/sort/insert/test/",
    "insertsort_small": "./test_pack/c/sort/insert/small/",
    "insertsort_mid": "./test_pack/c/sort/insert/mid/",
    "quicksort": "./test_pack/c/sort/quick/test/",
    "quicksort_small": "./test_pack/c/sort/quick/small/",
    "quicksort_mid": "./test_pack/c/sort/quick/mid/",
    "quicksort_large": "./test_pack/c/sort/quick/large/",
    "load": "./test_pack/asm/load/",    # IN_TOTAL: 1000000
    "store": "./test_pack/asm/store/",  # IN_TOTAL: 1000000
    "load_use": "./test_pack/asm/load_use/",
    "p2": "./test_pack/asm/p2/",
    "p2_part": "./test_pack/asm/p2_part/",
    "csr": "./test_pack/asm/csr/",
    "mret": "./test_pack/asm/mret/",
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

    import time
    start = time.time()
    subprocess.run(simulation_command)
    end = time.time()
    print(f"Time taken in real life: {end - start} [s]")

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