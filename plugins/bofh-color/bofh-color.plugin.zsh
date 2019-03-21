#!/bin/zsh
echo 
alias bofh='$ZSH/plugins/bofh/bofh.plugin.zsh'
curl -o - https://bofh.tips/ 2>/dev/null | lolcat
