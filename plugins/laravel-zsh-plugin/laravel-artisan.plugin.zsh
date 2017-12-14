# laravel 5.3 artisan command aliases

function artisan() {
    php artisan $*
}
function art_make() {
    artisan make:$*
}
alias a='artisan'
alias av='artisan -V'
alias acc='artisan clear-compiled'
alias ad='artisan down'
alias ae='artisan env'
alias ah='artisan help'
alias ai='artisan inspire'
alias al='artisan list'
alias ao='artisan optimize'
alias ap='artisan preset'
alias as='artisan serve'
alias at='artisan tinker'
alias au='artisan up'
alias aanm='artisan app:name'
alias aacr='artisan auth:clear-resets'
# cache
alias accl='artisan cache:clear'
alias actb='artisan cache:table'
# config
alias acfcc='artisan config:cache'
alias acfcl='artisan config:clear'
#
alias adbs='artisan db:seed'
alias aeg='artisan event:generate'
alias akg='artisan key:generate'
# make
alias amkau='art_make auth'
alias amkcm='art_make command'
alias amkct='art_make controller'
alias amkctr='art_make controller -r'
alias amkev='art_make event'
alias amkfc='art_make factory'
alias amkjb='art_make job'
alias amkls='art_make listener'
alias amkml='art_make mail'
alias amkmw='art_make middleware'
alias amkmg='art_make migration'
alias amkmd='art_make model'
alias amkmdm='art_make model -m'
alias amknf='art_make notification'
alias amkpl='art_make policy'
alias amkpv='art_make provider'
alias amkrq='art_make request'
alias amkres='art_make resource'
alias amkrl='art_make rule'
alias amksd='art_make seeder'
alias amkts='art_make test'
# migrate
alias amg='artisan migrate'
alias amgf='artisan migrate --force'
alias amgs='artisan migrate --seed'
alias amgp='artisan migrate --pretend'
alias amgt='artisan migrate --env=testing'
alias amgfr='artisan migrate:fresh'
alias amgis='artisan migrate:install'
alias amgrf='artisan migrate:refresh'
alias amgrs='artisan migrate:reset'
alias amgrb='artisan migrate:rollback'
alias amgst='artisan migrate:status'
#notifications
alias anftb='artisan notifications:table'
#package
alias apd='artisan package:discover'
# queue
alias aqf='artisan queue:failed'
alias aqft='artisan queue:failed-table'
alias aqfl='artisan queue:flush'
alias aqfg='artisan queue:forget'
alias aqls='artisan queue:listen'
alias aqrs='artisan queue:restart'
alias aqrt='artisan queue:retry'
alias aqtb='artisan queue:table'
alias aqwk='artisan queue:work'
# route
alias arcc='artisan route:cache'
alias arcl='artisan route:clear'
alias arls='artisan route:list'
#
alias asrn='artisan schedule:run'
alias astb='artisan session:table'
alias asln='artisan storage:link'
alias avpb='artisan vendor:publish'
alias avcl='artisan view:clear'

# laravel 5.2 artisan command aliases

alias amkcs='art_make console'

# laravel 5.1 artisan command aliases

alias ahcm='artisan handler:command'
alias ahev='artisan handler:event'
alias aqss='artisan queue:subscribe'

# laravel 5.0 artisan command aliases

alias afr='artisan fresh'
