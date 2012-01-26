# dot-env for oh-my-zsh

Adds 2 main features to oh-my-zsh:

1. Ability to customize and maintain your oh-my-zsh environments based on global preferences, machine OS type (Darwin, Linux, Solaris), and hostname
1. Ability to cascade the customizations in hierarchical fashion from global, to os type, to specific hostname

## Example

Let's say you work on a Macbook Pro with a hostname "John-Smiths-Macbook-Pro", but you also frequently work on the following different remote machines over SSH:

* rx23 - An Ubuntu 10.04 LTS box
* zebra - An Ubuntu 11.04 box
* sol-15 - A Solaris box
* technozero - A BSD box
* express - A CentOS box

You already know, if you work on different remote machines, when you login the first time none of your aliases, shell functions or environment settings are there.  What dot-env does is allow you to maintain a hierarchy of oh-my-zsh environment settings from global, down to specific host and to easily propagate those environments to each remote box from your local machine.

So we can have a local hierarchy of settings like this:

    root
    +- .oh-my-zsh
       +- plugins
          +- dot-env
             +- global
                +- global_aliases.sh
                +- global_functions.sh
                +- other_global_files.sh
             +- os
                +- Darwin
                   +- darwin_specific_aliases.sh
                   +- darwin_specific_functions.sh
                   +- etc.sh
                +- Linux
                +- SunOS
             +- host
                +- rx23
                   +- rx23_specific_aliases.sh
                   +- rx23_specific_functions.sh
                   +- etc.sh
                +- John-Smiths-Macbook-Pro.local
                   +- local_specific_aliases.sh
                   +- local_specific_functions.sh
                   +- local_etc.sh
               +- etc...

This hierarchy gets loaded in a cascading fashion as follows:

- If you login to rx23:
    1. dot-env-plugin.zsh
    1. global/*.sh
    1. os/Linux/*.sh
    1. host/rx23/*.sh
- If you login to John-Smiths-Macbook-Pro
    1. dot-env-plugin.zsh
    1. global/*.sh
    1. os/Darwin/*.sh
    1. host/John-Smiths-Macbook-Pro.local/*.sh

There are some helpful functions to maintain things:

    config_omzs_for_this_host # stubs out a hierarchy for the current host that you can edit to taste

    config_omzs_for_host      # stubs out a hierarchy for a specified remote hostname

    add_ssh_key_to_host       # copy your .ssh/id_rsa.pub or id_dsa.pub key to a remote host

    propagate_omzs_to_host    # copies your ~/.oh-my-zsh directory to a remote host

    load_omzs_on_alias        # run this on a remote host to setup an alias 'omzs' to load oh-my-zsh

    load_omzs_on_login        # run this on a remote host to have it automatically source oh-my-zsh on login

* `config_omzs_for_this_host` - no arguments, just creates a directory structure for your local machine and stubs out a few .sh files

* `config_omzs_for_host` - "Usage: config_omzs_for_host HOSTNAME" - creates a directory structure for your remote machine and stubs out a few .sh files

* `add_ssh_key_to_host` - "Usage: add_ssh_key_to_host [user@]HOSTNAME" - Add your public SSH key to a remote host. You may have to enter your password up to 3 times.  After that it will be passwordless if the remote sshd server is setup to allow it

* The `load_omzs_on_alias` function is nice if others also use that account and you don't want to force them to use your oh-my-zsh settings.

* `propagate_omzs_to_host` - "Usage: propagate_omzs_to_host [user@]HOSTNAME" - compresses your `~/.oh-my-zsh` directory, uploads it to the specified host account, decompresses it and reminds you to run one of `load_omzs_on_alias` or `load_omzs_on_login`

