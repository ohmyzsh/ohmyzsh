#!/usr/bin/env python
<<<<<<< HEAD
# -*- coding: UTF-8 -*-
from subprocess import Popen, PIPE
import re

# change those symbols to whatever you prefer
symbols = {
    'ahead of': '↑',
    'behind': '↓',
    'staged': '♦',
    'changed': '‣',
    'untracked': '…',
    'clean': '⚡',
    'unmerged': '≠',
    'sha1': ':'
}

output, error = Popen(
    ['git', 'status'], stdout=PIPE, stderr=PIPE, universal_newlines=True).communicate()

if error:
    import sys
    sys.exit(0)
lines = output.splitlines()

behead_re = re.compile(
    r"^# Your branch is (ahead of|behind) '(.*)' by (\d+) commit")
diverge_re = re.compile(r"^# and have (\d+) and (\d+) different")

status = ''
staged = re.compile(r'^# Changes to be committed:$', re.MULTILINE)
changed = re.compile(r'^# Changed but not updated:$', re.MULTILINE)
untracked = re.compile(r'^# Untracked files:$', re.MULTILINE)
unmerged = re.compile(r'^# Unmerged paths:$', re.MULTILINE)


def execute(*command):
    out, err = Popen(stdout=PIPE, stderr=PIPE, *command).communicate()
    if not err:
        nb = len(out.splitlines())
    else:
        nb = '?'
    return nb

if staged.search(output):
    nb = execute(
        ['git', 'diff', '--staged', '--name-only', '--diff-filter=ACDMRT'])
    status += '%s%s' % (symbols['staged'], nb)
if unmerged.search(output):
    nb = execute(['git', 'diff', '--staged', '--name-only', '--diff-filter=U'])
    status += '%s%s' % (symbols['unmerged'], nb)
if changed.search(output):
    nb = execute(['git', 'diff', '--name-only', '--diff-filter=ACDMRT'])
    status += '%s%s' % (symbols['changed'], nb)
if untracked.search(output):
    status += symbols['untracked']
if status == '':
    status = symbols['clean']

remote = ''

bline = lines[0]
if bline.find('Not currently on any branch') != -1:
    branch = symbols['sha1'] + Popen([
        'git',
        'rev-parse',
        '--short',
        'HEAD'], stdout=PIPE).communicate()[0][:-1]
else:
    branch = bline.split(' ')[-1]
    bstatusline = lines[1]
    match = behead_re.match(bstatusline)
    if match:
        remote = symbols[match.groups()[0]]
        remote += match.groups()[2]
    elif lines[2:]:
        div_match = diverge_re.match(lines[2])
        if div_match:
            remote = "{behind}{1}{ahead of}{0}".format(
                *div_match.groups(), **symbols)

print('\n'.join([branch, remote, status]))
=======
from __future__ import print_function

import os
import sys
import re
from subprocess import Popen, PIPE, check_output


def get_tagname_or_hash():
    """return tagname if exists else hash"""
    # get hash
    hash_cmd = ['git', 'rev-parse', '--short', 'HEAD']
    hash_ = check_output(hash_cmd).decode('utf-8').strip()

    # get tagname
    tags_cmd = ['git', 'for-each-ref', '--points-at=HEAD', '--count=2', '--sort=-version:refname', '--format=%(refname:short)', 'refs/tags']
    tags = check_output(tags_cmd).decode('utf-8').split()

    if tags:
        return tags[0] + ('+' if len(tags) > 1 else '')
    elif hash_:
        return hash_
    return None

# Re-use method from https://github.com/magicmonty/bash-git-prompt to get stashs count
def get_stash():
    cmd = Popen(['git', 'rev-parse', '--git-dir'], stdout=PIPE, stderr=PIPE)
    so, se = cmd.communicate()
    stash_file = '%s%s' % (so.decode('utf-8').rstrip(), '/logs/refs/stash')

    try:
        with open(stash_file) as f:
            return sum(1 for _ in f)
    except IOError:
        return 0


# `git status --porcelain --branch` can collect all information
# branch, remote_branch, untracked, staged, changed, conflicts, ahead, behind
po = Popen(['git', 'status', '--porcelain', '--branch'], env=dict(os.environ, LANG="C"), stdout=PIPE, stderr=PIPE)
stdout, sterr = po.communicate()
if po.returncode != 0:
    sys.exit(0)  # Not a git repository

# collect git status information
untracked, staged, changed, conflicts = [], [], [], []
ahead, behind = 0, 0
status = [(line[0], line[1], line[2:]) for line in stdout.decode('utf-8').splitlines()]
for st in status:
    if st[0] == '#' and st[1] == '#':
        if re.search('Initial commit on', st[2]) or re.search('No commits yet on', st[2]):
            branch = st[2].split(' ')[-1]
        elif re.search('no branch', st[2]):  # detached status
            branch = get_tagname_or_hash()
        elif len(st[2].strip().split('...')) == 1:
            branch = st[2].strip()
        else:
            # current and remote branch info
            branch, rest = st[2].strip().split('...')
            if len(rest.split(' ')) == 1:
                # remote_branch = rest.split(' ')[0]
                pass
            else:
                # ahead or behind
                divergence = ' '.join(rest.split(' ')[1:])
                divergence = divergence.lstrip('[').rstrip(']')
                for div in divergence.split(', '):
                    if 'ahead' in div:
                        ahead = int(div[len('ahead '):].strip())
                    elif 'behind' in div:
                        behind = int(div[len('behind '):].strip())
    elif st[0] == '?' and st[1] == '?':
        untracked.append(st)
    else:
        if st[1] == 'M':
            changed.append(st)
        if st[0] == 'U':
            conflicts.append(st)
        elif st[0] != ' ':
            staged.append(st)

stashed = get_stash()
if not changed and not staged and not conflicts and not untracked:
    clean = 1
else:
    clean = 0

out = ' '.join([
    branch,
    str(ahead),
    str(behind),
    str(len(staged)),
    str(len(conflicts)),
    str(len(changed)),
    str(len(untracked)),
    str(stashed),
    str(clean)
])
print(out, end='')
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
