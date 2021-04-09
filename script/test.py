# python3

from typing import List

def input_files_provided(sys_argv: List[str]) -> bool:
    return len(sys_argv) > 1

def files_in_path(path: str = './') -> List[str]:
    from os import listdir
    from os.path import isfile, join

    return [join(path, filename) for filename in listdir(path) if isfile(join(path, filename))]

def files_in_src_and_test() -> List[str]:
    return files_in_path(path='./src/') + files_in_path(path='./test/')

def select_filenames_by_file_format(filenames: List[str], format: str) -> List[str]:
    selected_filenames = []

    for filename in filenames:
        if (filename.endswith(f'.{format}')):
            selected_filenames.append(filename)

    return selected_filenames

def select_verilog_files(filenames: List[str]) -> List[str]:
    return select_filenames_by_file_format(filenames, 'v')

def verilog_files_for_test_from_module_names(module_names: List[str]) -> List[str]:
    verilog_files_for_test = []
    for module in module_names:
        verilog_files_for_test.append(f'./src/{module}.v') 
        verilog_files_for_test.append(f'./test/test_{module}.v')

    return verilog_files_for_test

def verilog_files_for_test() -> List[str]:
    import sys
    sys_argv = sys.argv

    if input_files_provided(sys_argv):
        return verilog_files_for_test_from_module_names(sys_argv[1:])
    else:
        return select_verilog_files(files_in_src_and_test())

def run_test(files_to_include: List[str]):
    print(f'files_for_test: {files_to_include}')
    if len(files_to_include) <= 0:
        print('no files available for testing.')

        import sys
        sys.exit(1)
        
    import subprocess
    test_command = f"xmverilog -s +gui +access+r {' '.join(files_to_include)}".split()
    subprocess.run(test_command)

if __name__ == "__main__":
    files_for_test = verilog_files_for_test()
    run_test(files_for_test)
