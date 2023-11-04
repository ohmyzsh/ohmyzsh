# EMERGE
alias emin='sudo emerge '
alias eminsl='sudo emerge -K '
alias eminsr='sudo emerge -G '
alias emre='sudo emerge -C '
alias emsearch='emerge -s '
alias emsync='sudo emerge --sync '
alias emup='sudo emerge -aDuN world '
alias emclean='sudo emerge --depclean '

# PORTAGEQ
alias pocolor='portageq colormap '
alias podist='portageq distdir '
alias povar='portageq envvar '
alias pomirror='portageq gentoo_mirrors'
alias poorphan='portageq --orphaned '

# GENLOP
alias genstroy='sudo genlop -l '
alias geneta='sudo genlop -c '
alias genweta='watch -ct -n 1 sudo genlop -c '
alias geninfo='sudo genlop -i '
alias genustory='sudo genlop -u '
alias genstorytime='sudo genlop -t '

# QLOP
alias qsummary='sudo qlop -c '
alias qtime='sudo qlop -t '
alias qavg='sudo qlop -a '
alias qhum='sudo qlop -H '
alias qmachine='sudo qlop -M '
alias qmstory='sudo qlop -m '
alias qustory='sudo qlop -u '
alias qastory='sudo qlop -U '
alias qsstory='sudo qlop -s '
alias qend='sudo qlop -e '
alias qrun='sudo qlop -r '

# ECLEAN
alias distclean='sudo eclean --deep distfiles '
alias pkgclean='sudo eclean-pkg '

# EUSE
alias newuse='sudo euse -E '
alias deluse='sudo euse -D '

# VIM
alias make.conf='sudo vim /etc/portage/make.conf '
alias package.mask='sudo vim /etc/portage/package.mask '
alias package.use='sudo vim /etc/portage/package.use '
alias repos.conf='sudo vim /etc/portage/repos.conf '
