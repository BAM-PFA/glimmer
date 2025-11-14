#!/usr/bin/env python3
# written by John Lowe

import os
from pathlib import Path
import re
import shutil
import sys

tenant_list = ['bampfa','cinefiles','pahma']
if len(sys.argv) <=1 or sys.argv[1] not in tenant_list:
    print("Please specify a valid tenant from this list: "+', '.join(tenant_list))
    print("Like so: `python3 tenant_installer.py TENANT`")
    sys.exit(1)
else:
    tenant = sys.argv[1]
app_path = Path('portal/').resolve()

# start with clean directories
os.system('rm -rf portal/app/*')
os.system('rm -rf portal/config/*')
os.system('rm -rf portal/lib/*')
os.system('rm -rf portal/public/*')
os.system('rm -rf portal/spec/*')

# first copy over common files
os.chdir('ucb_extras/common')
common_dir = Path('.')
common_files = sorted(common_dir.glob('**/*.*'))
for file_path in common_files:
    common_file_resolved = file_path.resolve()
    print(common_file_resolved)
    dest_file = app_path.joinpath(file_path).resolve()
    dest_file.parent.mkdir(parents=True, exist_ok=True)
    Path(dest_file).touch(exist_ok=True)
    shutil.copyfile(common_file_resolved, dest_file)

    if file_path.suffix in['.jpg', '.png', '.py', '.svg', '.ttf']:
        continue

    tmp = str(dest_file)+".tmp"
    tmp_lines = []
    placeholder = "#TENANT#"
    with open(dest_file,'r') as f:
        lines = f.readlines()
        for line in lines:
            if placeholder in line:
                line = line.replace(placeholder, tenant)
            tmp_lines.append(line)
    with open(tmp,'w') as f:
        for line in tmp_lines:
            f.write(line)

    tmp = Path(tmp).resolve()
    shutil.copyfile(tmp, dest_file)
    tmp.unlink()

filename_pattern = re.compile(r'\w+\.\w+(\.\w+)?')

def log_path(path, names):
    for name in names:
        if filename_pattern.match(name):
            print(Path(path).joinpath(name).resolve())
    return []   # nothing will be ignored

# copy over tenant files
tenant_path = Path('../' + tenant)
os.chdir(tenant_path)
shutil.copytree(tenant_path, app_path, ignore=log_path, dirs_exist_ok=True)
print(f'\n🪄 ✨ Installed {tenant}')
