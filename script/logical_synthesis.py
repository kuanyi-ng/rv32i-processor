# python3

import subprocess

if __name__ == "__main__":
    # Copy from src/ to logical_synthesis_ground
    print("copying src files to logical_synthesis_ground")
    copy_command = f"sh script/cp_from_src_to_logical_synthesis_ground.sh".split()
    copy_result = subprocess.run(copy_command)
    if copy_result.returncode != 0:
        return_code = copy_result.returncode
        print(f'Copy failed with code: {return_code}')
        exit(return_code)

    # Perform Logical Synthesis
    print('start logical synthesis')
    synthesis_command = f"sh script/run_logical_synthesis.sh".split()
    synthesis_result = subprocess.run(synthesis_command)
    if synthesis_result.returncode != 0:
        return_code = synthesis_result.returncode
        print(f'Logical Synthesis failed with code: {return_code}')
        exit(return_code)
