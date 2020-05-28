# Vagrant plugin

This plugin adds autocompletion for [Vagrant](https://www.vagrantup.com/) commands, task names, box names and built-in handy documentation.

To use it, add `vagrant` to the plugins array in your zshrc file:

```zsh
plugins=(... vagrant)
```

## Aliases

| Alias   | Command                      |
|---------|------------------------------|
| `vgi`   | `vagrant init`               |
| `vup`   | `vagrant up`                 |
| `vd`    | `vagrant destroy`            |
| `vdf`   | `vagrant destroy -f`         |
| `vssh`  | `vagrant ssh`                |
| `vsshc` | `vagrant ssh-config`         |
| `vrdp`  | `vagrant rdp`                |
| `vh`    | `vagrant halt`               |
| `vssp`  | `vagrant suspend`            |
| `vst`   | `vagrant status`             |
| `vre`   | `vagrant resume`             |
| `vgs`   | `vagrant global-status`      |
| `vpr`   | `vagrant provision`          |
| `vr`    | `vagrant reload`             |
| `vrp`   | `vagrant reload --provision` |
| `vp`    | `vagrant push`               |
| `vsh`   | `vagrant share`              |
| `vba`   | `vagrant box add`            |
| `vbr`   | `vagrant box remove`         |
| `vbl`   | `vagrant box list`           |
| `vbo`   | `vagrant box outdated`       |
| `vbu`   | `vagrant box update`         |
| `vpli`  | `vagrant plugin install`     |
| `vpll`  | `vagrant plugin list`        |
| `vplun` | `vagrant plugin uninstall`   |
| `vplu`  | `vagrant plugin update`      |
