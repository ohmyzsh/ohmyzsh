function exist-path () {
    for p in $* ; do
        [[ -e $p ]] && echo $p && return;
    done
}
######
hash -d WWW=$(exist-path /home/lighttpd/html ~/ROR/)
hash -d MNT=$(exist-path /{mnt,media}/$USER /{mnt,media})
hash -d PKG=$(exist-path /var/cache/{pacman/pkg,apt/archives})
hash -d E="/etc/env.d"
hash -d C="/etc/conf.d"
hash -d I=$(exist-path /etc/{init.d,rc.d})
hash -d X="/etc/X11"
hash -d BK=$(exist-path /home/$USER/{config_bak,iff})
hash -d HIST="$HISTDIR"
