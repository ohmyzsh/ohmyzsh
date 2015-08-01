#!/usr/bin/env python
from __future__ import print_function

# change this symbol to whatever you prefer
prehash = ':'

from subprocess import Popen, PIPE

import sys
gitsym = Popen(['git', 'symbolic-ref', 'HEAD'], stdout=PIPE, stderr=PIPE)
branch, error = gitsym.communicate()

error_string = error.decode('utf-8')

if 'fatal: Not a git repository' in error_string:
	sys.exit(0)

branch = branch.decode("utf-8").strip()[11:]

res, err = Popen(['git','diff','--name-status'], stdout=PIPE, stderr=PIPE).communicate()
err_string = err.decode('utf-8')
if 'fatal' in err_string:
	sys.exit(0)
changed_files = [namestat[0] for namestat in res.decode("utf-8").splitlines()]
staged_files = [namestat[0] for namestat in Popen(['git','diff', '--staged','--name-status'], stdout=PIPE).communicate()[0].splitlines()]
nb_changed = len(changed_files) - changed_files.count('U')
nb_U = staged_files.count('U')
nb_staged = len(staged_files) - nb_U
staged = str(nb_staged)
conflicts = str(nb_U)
changed = str(nb_changed)
nb_untracked = len([0 for status in Popen(['git','status','--porcelain',],stdout=PIPE).communicate()[0].decode("utf-8").splitlines() if status.startswith('??')])
untracked = str(nb_untracked)

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
	staged,
	conflicts,
	changed,
	untracked,
	])
print(out, end='')

