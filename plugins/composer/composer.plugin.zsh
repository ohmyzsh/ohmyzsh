# main alias
if which composer.phar &> /dev/null; then
  if which composer &> /dev/null; then
  else
    alias composer="composer.phar"
  fi
else
  if which composer &> /dev/null; then
    alias composer.phar="composer"
  fi
fi

# other aliases                                                                                                                                                                                                                                                                       
alias c='composer'                                                                                                                                                                                                                                                              
alias csu='composer self-update'                                                                                                                                                                                                                                                
alias cu='composer update'                                                                                                                                                                                                                                                      
alias ci='composer install'                                                                                                                                                                                                                                                     
alias ccp='composer create-project'                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                                                
# install composer in the current directory                                                                                                                                                                                                                                     
alias cget='curl -s https://getcomposer.org/installer | php'