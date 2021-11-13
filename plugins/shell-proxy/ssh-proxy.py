#!/usr/bin/env python3
import os
import subprocess
import sys
import urllib.parse

proxy = next(os.environ[_] for _ in ("HTTP_PROXY", "HTTPS_PROXY") if _ in os.environ)
argv = [
    "nc",
    "-X",
    "connect",
    "-x",
    urllib.parse.urlparse(proxy).netloc,  # proxy-host:proxy-port
    sys.argv[1],  # host
    sys.argv[2],  # port
]

subprocess.call(argv)
