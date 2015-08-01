#!/usr/bin/env python
from __future__ import print_function

# change this symbol to whatever you prefer
prehash = ':'

import subprocess
from subprocess import Popen, PIPE

import sys
gitsym = Popen(['git', 'symbolic-ref', 'HEAD'], stdout=PIPE, stderr=PIPE)
branch, error = gitsym.communicate()

error_string = error.decode('utf-8')

if 'fatal: Not a git repository' in error_string:
    sys.exit(0)

branch = branch.decode("utf-8").strip()[11:]

# Get git status (staged, change, conflicts and untracked)
try:
    res = subprocess.check_output(['git', 'status', '--porcelain'])
except subprocess.CalledProcessError:
    sys.exit(0)
status = [(st[0], st[1], st[2:]) for st in res.splitlines()]
untracked, staged, changed, conflicts = [], [], [], []
for st in status:
    if st[0] == '?' and st[1] == '?':
        untracked.append(st)
    else:
        if st[1] == 'M':
            changed.append(st)
        if st[0] == 'U':
            conflicts.append(st)
        elif st[0] != ' ':
            staged.append(st)

ahead, behind = 0,0

if not branch: # not on any branch
    branch = prehash + Popen(['git','rev-parse','--short','HEAD'], stdout=PIPE).communicate()[0].decode("utf-8")[:-1]
else:
    remote_name = Popen(['git','config','branch.%s.remote' % branch], stdout=PIPE).communicate()[0].decode("utf-8").strip()
    if remote_name:
        merge_name = Popen(['git','config','branch.%s.merge' % branch], stdout=PIPE).communicate()[0].decode("utf-8").strip()
        if remote_name == '.': # local
            remote_ref = merge_name
        else:
            remote_ref = 'refs/remotes/%s/%s' % (remote_name, merge_name[11:])
        revgit = Popen(['git', 'rev-list', '--left-right', '%s...HEAD' % remote_ref],stdout=PIPE, stderr=PIPE)
        revlist = revgit.communicate()[0]
        if revgit.poll(): # fallback to local
            revlist = Popen(['git', 'rev-list', '--left-right', '%s...HEAD' % merge_name],stdout=PIPE, stderr=PIPE).communicate()[0]
        behead = revlist.decode("utf-8").splitlines()
        ahead = len([x for x in behead if x[0]=='>'])
        behind = len(behead) - ahead

out = ' '.join([
    branch,
    str(ahead),
    str(behind),
    str(len(staged)),
    str(len(conflicts)),
    str(len(changed)),
    str(len(untracked)),
])
print(out, end='')

