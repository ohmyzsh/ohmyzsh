# hexo basic command completion
_hexo_get_command_list () {
	hexo --no-ansi | awk '/(--|^ +[a-z]+)/{ print $1 }'
}

_hexo () {
    compadd `_hexo_get_command_list`

}

compdef _hexo hexo

alias hes="hexo server"
alias heg="hexo generate"
alias hed="hexo deploy"
