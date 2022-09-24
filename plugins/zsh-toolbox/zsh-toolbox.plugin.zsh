#this is plugin with many functionalities.
#you need to add this to your .zshrc file
#to allow for ls -a to be aliased as ls:
#lsa=1
lsa="0"
if [[ "lsa" == "1" ]]
then 
alias ls=ls -a
fi
alias mz=omz