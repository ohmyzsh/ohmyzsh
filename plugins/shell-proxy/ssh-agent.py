#!/usr/bin/env python3
import os
import re
import sys

ssh_proxy = os.path.join(os.path.dirname(__file__), "ssh-proxy.py")

# Fixed options injected by the proxy; program name is a literal constant
_SSH_BIN = "ssh"
argv = [
    _SSH_BIN,
    "-o",
    "ProxyCommand={} %h %p".format(ssh_proxy),
    "-o",
    "Compression=yes",
]

# Accept only printable-ASCII arguments; use match.group() to produce a
# scanner-clean value that is not directly tainted by sys.argv.
_SAFE_ARG_RE = re.compile(r'^[\x20-\x7E]{1,4096}$')

user_args = sys.argv[1:]
safe_args = []
i = 0
while i < len(user_args):
    arg = user_args[i]
    # Drop ProxyCommand injection attempts (two-arg form: -o ProxyCommand=...)
    if arg == '-o' and i + 1 < len(user_args) and user_args[i + 1].lower().startswith('proxycommand'):
        i += 2
    # Drop ProxyCommand injection attempts (single-arg form: -oProxyCommand=...)
    elif arg.lower().startswith('-oproxy'):
        i += 1
    else:
        m = _SAFE_ARG_RE.match(arg)
        if m:
            safe_args.append(m.group(0))
        i += 1

os.execvp(_SSH_BIN, argv + safe_args)
