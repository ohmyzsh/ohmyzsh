
VW_SCRIPT=`which virtualenvwrapper.sh`
if [ -f $VW_SCRIPT ]; then
    export WORKON_HOME="~/virtualenvs"
    source $VW_SCRIPT
fi
