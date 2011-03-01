# hub alias from defunkt
# https://github.com/defunkt/hub
if [ $( which hub > /dev/null 2>&1 ; echo -n $? ) -lt 1 ]; then
    eval $( hub alias -s $( ps -o comm= -p $$ ) )
fi
