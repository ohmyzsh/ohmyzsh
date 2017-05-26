import os
import sys

def get_subpaths(path):
    paths = []
    dirs = path.split('/')[1:]

    for i in range(len(dirs), 0, -1):
        p = os.path.join(*dirs[0:i])
        yield p

def has_modules_folder(path):
    check_path = os.path.join('/', path, 'node_modules')
    return os.path.exists(check_path) and os.path.isdir(check_path)

def get_closes_path_dir(path):
    for p in get_subpaths(path):
        if has_modules_folder(p):
            return '/' + p
    return ''

if __name__ == '__main__':
    if len(sys.argv) == 1:
        sys.exit(1)
    else:
        path = sys.argv[1]
        print get_closes_path_dir(path)
        sys.exit(0)
