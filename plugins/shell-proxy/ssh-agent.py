#!/usr/bin/env python3
import os
import subprocess
import sys

ssh_proxy = os.path.join(os.path.dirname(__file__), "ssh-proxy.py")

argv = [
    os.environ.get("__SSH_PROGRAM_NAME__", "ssh"),
    "-o",
    "ProxyCommand={} %h %p".format(ssh_proxy),
    "-o",
    "Compression=yes",
]


def _validate_args(args):
    """Validate arguments to prevent command injection attacks.

    Rejects any argument containing shell metacharacters that could be
    used to inject arbitrary commands, even when shell=False is used,
    as a defense-in-depth measure.
    """
    dangerous_chars = frozenset({';', '&', '|', '`', '\n', '\r', '\0'})
    for arg in args:
        if any(c in arg for c in dangerous_chars):
            print("ssh-agent: invalid argument rejected: {}".format(arg), file=sys.stderr)
            sys.exit(1)
    return list(args)


subprocess.call(argv + _validate_args(sys.argv[1:]), env=os.environ, shell=False)
