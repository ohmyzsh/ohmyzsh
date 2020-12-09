#!/usr/bin/env python3
import os
import sys
from subprocess import check_output, list2cmdline

cwd = os.path.dirname(__file__)
ssh_agent = os.path.join(cwd, "ssh-agent.py")
user_proxy = os.environ.get("CONFIG_PROXY", os.path.expandvars("$HOME/.config/proxy"))


def get_http_proxy():
    if "DEFAULT_PROXY" in os.environ:
        return os.environ["DEFAULT_PROXY"]
    if os.path.isfile(user_proxy):
        return check_output(user_proxy).decode("utf-8").strip()
    raise Exception("Not found, Proxy configuration")


def make_proxies(url: str):
    proxies = {"%s_PROXY" % _: url for _ in ("HTTP", "HTTPS", "FTP", "RSYNC", "ALL")}
    proxies.update({name.lower(): value for (name, value) in proxies.items()})
    proxies["GIT_SSH"] = ssh_agent
    return proxies


def merge(mapping: dict):
    return ("%s=%s" % _ for _ in mapping.items())


class CommandSet:
    proxies = make_proxies(get_http_proxy())
    aliases = {
        _: "env __SSH_PROGRAM_NAME__=%s %s" % (_, ssh_agent)
        for _ in ("ssh", "sftp", "scp", "slogin", "ssh-copy-id")
    }

    def enable(self):
        cmdline("export", *merge(self.proxies))
        cmdline("alias", *merge(self.aliases))

    def disable(self):
        cmdline("unset", *self.proxies.keys())
        cmdline("unalias", *self.aliases.keys())

    def status(self):
        proxies = (
            "%11s = %s" % (name, os.environ[name])
            for name in self.proxies.keys()
            if name in os.environ
        )
        for _ in proxies:
            cmdline("echo", _)

    def usage(self):
        cmdline("echo", "usage: proxy {enable,disable,status}")
        self.status()


def cmdline(*items):
    print(list2cmdline(items))


def main():
    command = CommandSet()
    if len(sys.argv) == 1:
        command.usage()
        sys.exit(-1)
    getattr(command, sys.argv[1], command.usage)()


if __name__ == "__main__":
    main()
