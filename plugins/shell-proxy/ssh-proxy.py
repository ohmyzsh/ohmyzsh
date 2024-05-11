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

def make_argv():
    yield "nc"
    if sys.platform in {'linux', 'cygwin'}:
        # caveats: the built-in netcat of most linux distributions and cygwin support proxy type
        # caveats: macOS built-in netcat command not supported proxy-type
        yield "-X" # --proxy-type
        # Supported protocols are 4 (SOCKS v4), 5 (SOCKS v5) and connect (HTTP proxy).
        # Default SOCKS v5 is used.
        yield proxy_protocols[parsed.scheme]
    yield "-x" # --proxy
    yield parsed.netloc # proxy-host:proxy-port
    yield sys.argv[1] # host
    yield sys.argv[2] # port

subprocess.call(make_argv())
