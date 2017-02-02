# Rails

Ruby on Rails (http://rubyonrails.org/)

## List of Aliases

### Utility aliases
alias | command
---------- | -------------------------------
**devlog** | *tail -f log/development.log*
**prodlog** | *tail -f log/production.log*
**testlog** | *tail -f log/test.log*

### Environment setting
alias | command
---------- | -------------------------------
**-g RED** | *RAILS_ENV=development*
**-g REP** | *RAILS_ENV=production*
**-g RET** | *RAILS_ENV=test*

### Rails aliases
alias | rails command
---------- | -------------------------------
**rc** | *rails console*
**rcs** | *rails console --sandbox*
**rd** | *rails destroy*
**rdb** | *rails dbconsole*
**rg** | *rails generate*
**rgm** | *rails generate migration*
**rp** | *rails plugin*
**ru** | *rails runner*
**rs** | *rails server*
**rsd** | *rails server --debugger*
**rsp** | *rails server --port*

### Rake aliases
alias | rake command
---------- | -------------------------------
**rdm** | *rake db:migrate*
**rdms** | *rake db:migrate:status*
**rdr** | *rake db:rollback*
**rdc** | *rake db:create*
**rds** | *rake db:seed*
**rdd** | *rake db:drop*
**rdrs** | *rake db:reset*
**rdtc** | *rake db:test:clone*
**rdtp** | *rake db:test:prepare*
**rdmtc** | *rake db:migrate db:test:clone*
**rdsl** | *rake db:schema:load*
**rlc** | *rake log:clear*
**rn** | *rake notes*
**rr** | *rake routes*
**rrg** | *rake routes | grep*
**rt** | *rake test*
**rmd** | *rake middleware*
**rsts** | *rake stats*

### Legacy stuff
alias | command
---------- | -------------------------------
**sstat** | *thin --stats "/thin/stats" start*
**sg** | *ruby script/generate*
**sd** | *ruby script/destroy*
**sp** | *ruby script/plugin*
**sr** | *ruby script/runner*
**ssp** | *ruby script/spec*
**sc** | *ruby script/console*
**sd** | *ruby script/server --debugger*
