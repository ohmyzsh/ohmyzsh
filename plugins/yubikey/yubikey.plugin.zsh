local _libname='opensc-pkcs11.so'
local _sshfiledir="/run/user/$UID"
local _sshfile='ssh_agent'
local _sshpath=''
local _ellipsis='......'

if [[ -z $OPENSC ]]; then
    for f in $(locate "/${_libname}"); do
        [[ -L $f ]] && continue  # Is a symlink
        OPENSC="$f"
        break
    done
fi
export OPENSC

if [[ -w $_sshfiledir ]]; then
    _sshpath="$_sshfiledir/$_sshfile"
else
    _sshpath="/tmp/$_sshfile"
fi


alias yubi-init="pkill ssh-agent; pkill gpg-agent; ssh-agent -s > $_sshpath; source $_sshpath"
alias yubi-insert="ssh-add -s $OPENSC && ssh-add -L"
alias yubi-eject="ssh-add -e $OPENSC && ssh-add -L"

if [[ -r $_sshpath ]]; then
    echo -n "Common SSH Agent detected. "
    source $_sshpath
else
    echo -n "Common SSH Agent not detected. "
    case "${(U)YUBI_SSHAGENT_AUTOINIT}" in
        1|Y|YES)
            echo -n "Auto-initializing... "
            yubi-init
            echo "done."
            ;;
        *)
            echo "Autoinit not enabled. Use 'yubi-init' to manually init."
            ;;
    esac
fi

case "${(U)YUBI_SHOWKEYS}" in
    1|Y|YES)
        ssh-add -L | while read ln; do
            if (( ${#ln} >= COLUMNS )); then
                newlen=$(( COLUMNS - ${#_ellipsis} - 1 ))
                halflen=$(( newlen / 2 ))
                ln="${ln:0:$halflen}${_ellipsis}${ln: -$halflen}"
            fi
            echo "$ln"
        done
        ;;
esac

# vim: set ft=zsh ts=4 sts=4 et ai :
