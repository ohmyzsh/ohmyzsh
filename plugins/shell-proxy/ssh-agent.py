#!/usr/bin/env python3
import os
import subprocess
import sys

ssh_proxy = os.path.join(os.path.dirname(__file__), "ssh-proxy.py")

argv = [
    os.environ.get("NAME", "ssh"),
    "-o",
    "ProxyCommand={} %h %p".format(ssh_proxy),
    "-o",
    "Compression=yes",
]

subprocess.call(argv + sys.argv[1:], env=os.environ)
