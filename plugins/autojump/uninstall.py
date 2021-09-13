#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function

import os
import platform
import shutil
import sys

sys.path.append('bin')
from autojump_argparse import ArgumentParser  # noqa


def is_empty_dir(path):
    """
    Checks if any files are present within a directory and all sub-directories.
    """
    for _, _, files in os.walk(path):
        if files:
            return False
    return True


def parse_arguments():
    default_clink_dir = os.path.join(os.getenv('LOCALAPPDATA', ''), 'clink')

    parser = ArgumentParser(
        description='Uninstalls autojump.',
    )
    parser.add_argument(
        '-n', '--dryrun', action='store_true', default=False,
        help='simulate installation',
    )
    parser.add_argument(
        '-u', '--userdata', action='store_true', default=False,
        help='delete user data',
    )
    parser.add_argument(
        '-d', '--destdir', metavar='DIR',
        help='custom destdir',
    )
    parser.add_argument(
        '-p', '--prefix', metavar='DIR', default='',
        help='custom prefix',
    )
    parser.add_argument(
        '-z', '--zshshare', metavar='DIR', default='functions',
        help='custom zshshare',
    )
    parser.add_argument(
        '-c', '--clinkdir', metavar='DIR', default=default_clink_dir,
    )

    return parser.parse_args()


def remove_custom_installation(args, dryrun=False):
    if not args.destdir:
        return

    bin_dir = os.path.join(args.destdir, args.prefix, 'bin')
    doc_dir = os.path.join(args.destdir, args.prefix, 'share', 'man', 'man1')
    etc_dir = os.path.join(args.destdir, 'etc', 'profile.d')
    share_dir = os.path.join(args.destdir, args.prefix, 'share', 'autojump')
    zshshare_dir = os.path.join(args.destdir, args.zshshare)

    if not os.path.exists(share_dir):
        return

    print('\nFound custom installation...')
    rm(os.path.join(bin_dir, 'autojump'), dryrun)
    rm(os.path.join(bin_dir, 'autojump_data.py'), dryrun)
    rm(os.path.join(bin_dir, 'autojump_utils.py'), dryrun)
    rm(os.path.join(bin_dir, 'autojump_argparse.py'), dryrun)
    if platform.system() == 'Windows':
        if os.path.exists(args.clinkdir):
            rm(os.path.join(args.clinkdir, 'autojump.lua'), dryrun)
        rm(os.path.join(bin_dir, 'autojump.bat'), dryrun)
        rm(os.path.join(bin_dir, 'j.bat'), dryrun)
        rm(os.path.join(bin_dir, 'jc.bat'), dryrun)
        rm(os.path.join(bin_dir, 'jco.bat'), dryrun)
        rm(os.path.join(bin_dir, 'jo.bat'), dryrun)
    else:
        rm(os.path.join(etc_dir, 'autojump.sh'), dryrun)
        rm(os.path.join(share_dir, 'autojump.bash'), dryrun)
        rm(os.path.join(share_dir, 'autojump.fish'), dryrun)
        rm(os.path.join(share_dir, 'autojump.tcsh'), dryrun)
        rm(os.path.join(share_dir, 'autojump.zsh'), dryrun)
        rm(os.path.join(zshshare_dir, '_j'), dryrun)
    rmdir(share_dir, dryrun)
    rm(os.path.join(doc_dir, 'autojump.1'), dryrun)

    if is_empty_dir(args.destdir):
        rmdir(args.destdir, dryrun)


def remove_system_installation(dryrun=False):
    default_destdir = '/'
    default_prefix = '/usr/local'
    default_zshshare = '/usr/share/zsh/site-functions'

    bin_dir = os.path.join(default_destdir, default_prefix, 'bin')
    doc_dir = os.path.join(
        default_destdir,
        default_prefix,
        'share',
        'man',
        'man1',
    )
    etc_dir = os.path.join(default_destdir, 'etc', 'profile.d')
    share_dir = os.path.join(
        default_destdir,
        default_prefix,
        'share',
        'autojump',
    )
    zshshare_dir = os.path.join(default_destdir, default_zshshare)

    if not os.path.exists(share_dir):
        return

    print('\nFound system installation...')

    if os.geteuid() != 0:
        print(
            'Please rerun as root for system-wide uninstall, skipping...',
            file=sys.stderr,
        )
        return

    rm(os.path.join(bin_dir, 'autojump'), dryrun)
    rm(os.path.join(bin_dir, 'autojump_data.py'), dryrun)
    rm(os.path.join(bin_dir, 'autojump_utils.py'), dryrun)
    rm(os.path.join(etc_dir, 'autojump.sh'), dryrun)
    rm(os.path.join(share_dir, 'autojump.bash'), dryrun)
    rm(os.path.join(share_dir, 'autojump.fish'), dryrun)
    rm(os.path.join(share_dir, 'autojump.tcsh'), dryrun)
    rm(os.path.join(share_dir, 'autojump.zsh'), dryrun)
    rm(os.path.join(zshshare_dir, '_j'), dryrun)
    rmdir(share_dir, dryrun)
    rm(os.path.join(doc_dir, 'autojump.1'), dryrun)


def remove_user_data(dryrun=False):
    if platform.system() == 'Darwin':
        data_home = os.path.join(
            os.path.expanduser('~'),
            'Library',
            'autojump',
        )
    elif platform.system() == 'Windows':
        data_home = os.path.join(
            os.getenv('APPDATA'),
            'autojump',
        )
    else:
        data_home = os.getenv(
            'XDG_DATA_HOME',
            os.path.join(
                os.path.expanduser('~'),
                '.local',
                'share',
                'autojump',
            ),
        )

    if os.path.exists(data_home):
        print('\nFound user data...')
        rmdir(data_home, dryrun)


def remove_user_installation(dryrun=False):
    if platform.system() == 'Windows':
        default_destdir = os.path.join(
            os.getenv('LOCALAPPDATA', ''),
            'autojump',
        )
        clink_dir = os.path.join(os.getenv('LOCALAPPDATA', ''), 'clink')
    else:
        default_destdir = os.path.join(os.path.expanduser('~'), '.autojump')

    if os.path.exists(default_destdir):
        print('\nFound user installation...')
        rmdir(default_destdir, dryrun)
        if platform.system() == 'Windows' and os.path.exists(clink_dir):
            rm(os.path.join(clink_dir, 'autojump.lua'), dryrun)


def rm(path, dryrun):
    if os.path.exists(path):
        print('deleting file:', path)
        if not dryrun:
            os.remove(path)


def rmdir(path, dryrun):
    if os.path.exists(path):
        print('deleting directory:', path)
        if not dryrun:
            shutil.rmtree(path)


def main(args):
    if args.dryrun:
        print('Uninstalling autojump (DRYRUN)...')
    else:
        print('Uninstalling autojump...')

    remove_user_installation(args.dryrun)
    remove_system_installation(args.dryrun)
    remove_custom_installation(args, args.dryrun)
    if args.userdata:
        remove_user_data(args.dryrun)


if __name__ == '__main__':
    sys.exit(main(parse_arguments()))
