#!/usr/bin/env python2
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
