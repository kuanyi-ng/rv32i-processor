from typing import List

def files_in_path(path: str = './') -> List[str]:
    from os import listdir
    from os.path import isfile, join

    return [join(path, filename) for filename in listdir(path) if isfile(join(path, filename))]

def select_filenames_by_file_format(filenames: List[str], format: str) -> List[str]:
    selected_filenames = []

    for filename in filenames:
        if (filename.endswith(f'.{format}')):
            selected_filenames.append(filename)

    return selected_filenames

def select_verilog_files(filenames: List[str]) -> List[str]:
    return select_filenames_by_file_format(filenames, 'v')
