# general
alias h='heroku'
alias hauto='heroku autocomplete $(echo $SHELL)'
alias hl='heroku local'

# log
alias hg='heroku logs'
alias hgt='heroku log tail'

# database
alias hpg='heroku pg'
alias hpsql='heroku pg:psql'
alias hpb='heroku pg:backups'
alias hpbc='heroku pg:backups:capture'
alias hpbd='heroku pg:backups:download'
alias hpbr='heroku pg:backups:restore'

# config
alias hc='heroku config'
alias hca='heroku config -a'
alias hcr='heroku config -r'
alias hcs='heroku config:set'
alias hcu='heroku config:unset'

# this function allow to load multi env set in a file
hcfile() {
  echo 'Which platform [-r/a name] ?'
  read platform
  echo 'Which file ?'
  read file
  while read line;
    do heroku config:set "$platform" "$line";
  done < "$file"
}

# apps and favorites
alias ha='heroku apps'
alias hpop='heroku create'
alias hkill='heroku apps:destroy'
alias hlog='heroku apps:errors'
alias hfav='heroku apps:favorites'
alias hfava='heroku apps:favorites:add'
alias hfavr='heroku apps:favorites:remove'
alias hai='heroku apps:info'
alias hair='heroku apps:info -r'
alias haia='heroku apps:info -a'

# auth
alias h2fa='heroku auth:2fa'
alias h2far='heroku auth:2fa:disable'

# access
alias hac='heroku access'
alias hacr='heroku access -r'
alias haca='heroku access -a'
alias hadd='heroku access:add'
alias hdel='heroku access:remove'
alias hup='heroku access:update'

# addons
alias hads='heroku addons -A'
alias hada='heroku addons -a'
alias hadr='heroku addons -r'
alias hadat='heroku addons:attach'
alias hadc='heroku addons:create'
alias hadel='heroku addons:destroy'
alias hadde='heroku addons:detach'
alias hadoc='heroku addons:docs'

# login
alias hin='heroku login'
alias hout='heroku logout'
alias hi='heroku login -i'
alias hwho='heroku auth:whoami'

# authorizations
alias hth='heroku authorizations'
alias hthadd='heroku authorizations:create'
alias hthif='heroku authorizations:info'
alias hthdel='heroku authorizations:revoke'
alias hthrot='heroku authorizations:rotate'
alias hthup='heroku authorizations:update'

# plugins
alias hp='heroku plugins'

# cert
alias hssl='heroku certs'
alias hssli='heroku certs:info'
alias hssla='heroku certs:add'
alias hsslu='heroku certs:update'
alias hsslr='heroku certs:remove'
