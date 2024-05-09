#!/usr/bin/env python3
import sys
import itertools
import termcolor
import argparse

def parse(line):
    left = line[0:line.find('=')].strip()
    right = line[line.find('=')+1:].strip('\'"\n ')
    try:
        cmd = next(part for part in right.split() if len([char for char in '=<>' if char in part])==0)
    except StopIteration:
        cmd = right
    return (left, right, cmd)

def cheatsheet(lines):
    exps = [ parse(line) for line in lines ]
    exps.sort(key=lambda exp:exp[2])
    cheatsheet = {'_default': []}
    for key, group in itertools.groupby(exps, lambda exp:exp[2]):
        group_list = [ item for item in group ]
        if len(group_list)==1:
            target_aliases = cheatsheet['_default']
        else:
            if key not in cheatsheet:
                cheatsheet[key] = []
            target_aliases = cheatsheet[key]
        target_aliases.extend(group_list)
    return cheatsheet

def pretty_print_group(key, aliases, highlight=None, only_groupname=False):
    if len(aliases) == 0:
        return
    group_hl_formatter = lambda g, hl: termcolor.colored(hl, 'yellow').join([termcolor.colored(part, 'red') for part in ('[%s]' % g).split(hl)])
    alias_hl_formatter = lambda alias, hl: termcolor.colored(hl, 'yellow').join([termcolor.colored(part, 'green') for part in ('\t%s = %s' % alias[0:2]).split(hl)])
    group_formatter = lambda g: termcolor.colored('[%s]' % g, 'red')
    alias_formatter = lambda alias: termcolor.colored('\t%s = %s' % alias[0:2], 'green')
    if highlight and len(highlight)>0:
        print (group_hl_formatter(key, highlight))
        if not only_groupname:
            print ('\n'.join([alias_hl_formatter(alias, highlight) for alias in aliases]))
    else:
        print (group_formatter(key))
        if not only_groupname:
            print ('\n'.join([alias_formatter(alias) for alias in aliases]))
    print ('')

def pretty_print(cheatsheet, wfilter, group_list=None, groups_only=False):
    sorted_key = sorted(cheatsheet.keys())
    for key in sorted_key:
        if group_list and key not in group_list:
            continue
        aliases = cheatsheet.get(key)
        if not wfilter:
            pretty_print_group(key, aliases, wfilter, groups_only)
        else:
            pretty_print_group(key, [ alias for alias in aliases if alias[0].find(wfilter)>-1 or alias[1].find(wfilter)>-1], wfilter)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Pretty print aliases.", prog="als")
    parser.add_argument('filter', nargs="*", metavar="<keyword>", help="search aliases matching keywords")
    parser.add_argument('-g', '--group', dest="group_list", action='append', help="only print aliases in given groups")
    parser.add_argument('--groups', dest='groups_only', action='store_true', help="only print alias groups")
    args = parser.parse_args()

    lines = sys.stdin.readlines()
    group_list = args.group_list or None
    wfilter = " ".join(args.filter) or None
    pretty_print(cheatsheet(lines), wfilter, group_list, args.groups_only)
