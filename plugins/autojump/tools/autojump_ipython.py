# -*- coding: utf-8 -*-
"""
IPython autojump magic

Written by keith hughitt <keith.hughitt@gmail.com>, based on an earlier
version by Mario Pastorelli <pastorelli.mario@gmail.com>.

To install, create a new IPython user profile by running:

    ipython profile create

And copy this file into the "startup" folder of your new profile (e.g.
"$HOME/.config/ipython/profile_default/startup/").

@TODO: extend %cd to call "autojump -a"
"""
from subprocess import PIPE
from subprocess import Popen

from IPython.core.magic import register_line_magic

ip = get_ipython()  # noqa


@register_line_magic
def j(path):
    cmd = ['autojump'] + path.split()
    newpath = Popen(
        cmd,
        stdout=PIPE,
        shell=False,
    ).communicate()[0].strip()

    if newpath:
        ip.magic('cd %s' % newpath.decode('utf-8'))


# remove from namespace
del j
