#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function

import os
import platform
import shutil
import sys

sys.path.append('bin')
from autojump_argparse import ArgumentParser  # noqa

SUPPORTED_SHELLS = ('bash', 'zsh', 'fish', 'tcsh')


def cp(src, dest, dryrun=False):
    print('copying file: %s -> %s' % (src, dest))
    if not dryrun:
        shutil.copy(src, dest)


def get_shell():
    return os.path.basename(os.getenv('SHELL', ''))


def mkdir(path, dryrun=False):
    print('creating directory:', path)
    if not dryrun and not os.path.exists(path):
        os.makedirs(path)


def modify_autojump_sh(etc_dir, share_dir, dryrun=False):
    """Append custom installation path to autojump.sh"""
    custom_install = '\
        \n# check custom install \
        \nif [ -s %s/autojump.${shell} ]; then \
        \n    source %s/autojump.${shell} \
        \nfi\n' % (share_dir, share_dir)

    with open(os.path.join(etc_dir, 'autojump.sh'), 'a') as f:
        f.write(custom_install)


def modify_autojump_lua(clink_dir, bin_dir, dryrun=False):
    """Prepend custom AUTOJUMP_BIN_DIR definition to autojump.lua"""
    custom_install = "local AUTOJUMP_BIN_DIR = \"%s\"\n" % bin_dir.replace(
        '\\',
        '\\\\',
    )
    clink_file = os.path.join(clink_dir, 'autojump.lua')
    with open(clink_file, 'r') as f:
        original = f.read()
    with open(clink_file, 'w') as f:
        f.write(custom_install + original)


def parse_arguments():  # noqa
    if platform.system() == 'Windows':
        default_user_destdir = os.path.join(
            os.getenv('LOCALAPPDATA', ''),
            'autojump',
        )
    else:
        default_user_destdir = os.path.join(
            os.path.expanduser('~'),
            '.autojump',
        )
    default_user_prefix = ''
    default_user_zshshare = 'functions'
    default_system_destdir = '/'
    default_system_prefix = '/usr/local'
    default_system_zshshare = '/usr/share/zsh/site-functions'
    default_clink_dir = os.path.join(os.getenv('LOCALAPPDATA', ''), 'clink')

    parser = ArgumentParser(
        description='Installs autojump globally for root users, otherwise \
            installs in current user\'s home directory.'
    )
    parser.add_argument(
        '-n', '--dryrun', action='store_true', default=False,
        help='simulate installation',
    )
    parser.add_argument(
        '-f', '--force', action='store_true', default=False,
        help='skip root user, shell type, Python version checks',
    )
    parser.add_argument(
        '-d', '--destdir', metavar='DIR', default=default_user_destdir,
        help='set destination to DIR',
    )
    parser.add_argument(
        '-p', '--prefix', metavar='DIR', default=default_user_prefix,
        help='set prefix to DIR',
    )
    parser.add_argument(
        '-z', '--zshshare', metavar='DIR', default=default_user_zshshare,
        help='set zsh share destination to DIR',
    )
    parser.add_argument(
        '-c', '--clinkdir', metavar='DIR', default=default_clink_dir,
        help='set clink directory location to DIR (Windows only)',
    )
    parser.add_argument(
        '-s', '--system', action='store_true', default=False,
        help='install system wide for all users',
    )

    args = parser.parse_args()

    if not args.force:
        if sys.version_info[0] == 2 and sys.version_info[1] < 6:
            print('Python v2.6+ or v3.0+ required.', file=sys.stderr)
            sys.exit(1)
        if args.system:
            if platform.system() == 'Windows':
                print(
                    'System-wide installation is not supported on Windows.',
                    file=sys.stderr,
                )
                sys.exit(1)
            elif os.geteuid() != 0:
                print(
                    'Please rerun as root for system-wide installation.',
                    file=sys.stderr,
                )
                sys.exit(1)

        if platform.system() != 'Windows' \
                and get_shell() not in SUPPORTED_SHELLS:
            print(
                'Unsupported shell: %s' % os.getenv('SHELL'),
                file=sys.stderr,
            )
            sys.exit(1)

    if args.destdir != default_user_destdir \
            or args.prefix != default_user_prefix \
            or args.zshshare != default_user_zshshare:
        args.custom_install = True
    else:
        args.custom_install = False

    if args.system:
        if args.custom_install:
            print(
                'Custom paths incompatible with --system option.',
                file=sys.stderr,
            )
            sys.exit(1)

        args.destdir = default_system_destdir
        args.prefix = default_system_prefix
        args.zshshare = default_system_zshshare

    return args


def show_post_installation_message(etc_dir, share_dir, bin_dir):
    if platform.system() == 'Windows':
        print('\nPlease manually add %s to your user path' % bin_dir)
    else:
        if get_shell() == 'fish':
            aj_shell = '%s/autojump.fish' % share_dir
            source_msg = 'if test -f %s; . %s; end' % (aj_shell, aj_shell)
            rcfile = '~/.config/fish/config.fish'
        else:
            aj_shell = '%s/autojump.sh' % etc_dir
            source_msg = '[[ -s %s ]] && source %s' % (aj_shell, aj_shell)

            if platform.system() == 'Darwin' and get_shell() == 'bash':
                rcfile = '~/.profile'
            else:
                rcfile = '~/.%src' % get_shell()

        print('\nPlease manually add the following line(s) to %s:' % rcfile)
        print('\n\t' + source_msg)
        if get_shell() == 'zsh':
            print('\n\tautoload -U compinit && compinit -u')

    print('\nPlease restart terminal(s) before running autojump.\n')


def main(args):
    if args.dryrun:
        print('Installing autojump to %s (DRYRUN)...' % args.destdir)
    else:
        print('Installing autojump to %s ...' % args.destdir)

    bin_dir = os.path.join(args.destdir, args.prefix, 'bin')
    etc_dir = os.path.join(args.destdir, 'etc', 'profile.d')
    doc_dir = os.path.join(args.destdir, args.prefix, 'share', 'man', 'man1')
    share_dir = os.path.join(args.destdir, args.prefix, 'share', 'autojump')
    zshshare_dir = os.path.join(args.destdir, args.zshshare)

    mkdir(bin_dir, args.dryrun)
    mkdir(doc_dir, args.dryrun)
    mkdir(etc_dir, args.dryrun)
    mkdir(share_dir, args.dryrun)

    cp('./bin/autojump', bin_dir, args.dryrun)
    cp('./bin/autojump_argparse.py', bin_dir, args.dryrun)
    cp('./bin/autojump_data.py', bin_dir, args.dryrun)
    cp('./bin/autojump_match.py', bin_dir, args.dryrun)
    cp('./bin/autojump_utils.py', bin_dir, args.dryrun)
    cp('./bin/icon.png', share_dir, args.dryrun)
    cp('./docs/autojump.1', doc_dir, args.dryrun)

    if platform.system() == 'Windows':
        cp('./bin/autojump.lua', args.clinkdir, args.dryrun)
        cp('./bin/autojump.bat', bin_dir, args.dryrun)
        cp('./bin/j.bat', bin_dir, args.dryrun)
        cp('./bin/jc.bat', bin_dir, args.dryrun)
        cp('./bin/jo.bat', bin_dir, args.dryrun)
        cp('./bin/jco.bat', bin_dir, args.dryrun)

        if args.custom_install:
            modify_autojump_lua(args.clinkdir, bin_dir, args.dryrun)
    else:
        mkdir(etc_dir, args.dryrun)
        mkdir(share_dir, args.dryrun)
        mkdir(zshshare_dir, args.dryrun)

        cp('./bin/autojump.sh', etc_dir, args.dryrun)
        cp('./bin/autojump.bash', share_dir, args.dryrun)
        cp('./bin/autojump.fish', share_dir, args.dryrun)
        cp('./bin/autojump.zsh', share_dir, args.dryrun)
        cp('./bin/_j', zshshare_dir, args.dryrun)

        if args.custom_install:
            modify_autojump_sh(etc_dir, share_dir, args.dryrun)

    show_post_installation_message(etc_dir, share_dir, bin_dir)


if __name__ == '__main__':
    sys.exit(main(parse_arguments()))
