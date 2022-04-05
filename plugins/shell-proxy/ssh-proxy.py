#!/usr/bin/env python3
import os
import subprocess
import sys
from urllib.parse import urlparse

proxy = next(os.environ[_] for _ in ("HTTP_PROXY", "HTTPS_PROXY") if _ in os.environ)

parsed = urlparse(proxy)

proxy_protocols = {
    "http": "connect",
    "https": "connect",
    "socks": "5",
    "socks5": "5",
    "socks4": "4",
    "socks4a": "4",
}

if parsed.scheme not in proxy_protocols:
    raise TypeError('unsupported proxy protocol: "{}"'.format(parsed.scheme))

argv = [
    "nc",
    "-X",
    proxy_protocols[parsed.scheme], # Supported protocols are 4 (SOCKS v4), 5 (SOCKS v5) and connect (HTTP proxy). Default SOCKS v5 is used.
    "-x",
    parsed.netloc,  # proxy-host:proxy-port
    sys.argv[1],  # host
    sys.argv[2],  # port
]

subprocess.call(argv)
