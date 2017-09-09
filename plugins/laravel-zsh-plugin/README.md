# laravel-zsh-plugin - artisan commands aliases of Laravel 5 Framework for zsh

`laravel-zsh-plugin` contains short aliases for all artisan commands
included to Laravel 5, 5.1, 5.2, 5.3, 5.4, 5.5 versions of framework. 

## Example

Without typing full artisan command in console, like:
```console
$ php artisan migrate --seed
```
    
there is more convenient alias:
```console
$ amgs
```
    
## Installation on oh-my-zsh

1. Go to `oh-my-zsh` plugins directory:

    ```console
    $ cd ~/.oh-my-zsh/plugins
    ```

2. Clone the repository into a new directory `laravel-artisan` :

    ```console
    git clone https://github.com/crazybooot/laravel-zsh-plugin.git laravel-artisan
    ```

3. Enable `laravel-artisan` plugin by adding to your .zshrc configuration file:

    ```console
    plugins=(laravel-artisan)
    ```

4. Restart your shell.

## Aliases

#### General

| Alias                | Command                                                                                                                                 |
|:---------------------|:--------------------------------|
| a                    | php artisan
| av                   | php artisan -V
| acc                  | php artisan clear-compiled
| ad                   | php artisan down
| ae                   | php artisan env
| ah                   | php artisan help
| ai                   | php artisan inspire
| al                   | php artisan list
| ao                   | php artisan optimize
| ap                   | php artisan preset
| as                   | php artisan serve
| at                   | php artisan tinker
| au                   | php artisan up
| aanm                 | php artisan app:name
| aacr                 | php artisan auth:clear-resets

#### Cache

| Alias                | Command                                                                                                                                 |
|:---------------------|:--------------------------------|
| accl                 | php artisan cache:clear
| actb                 | php artisan cache:table

#### Config

| Alias                | Command                                                                                                                                 |
|:---------------------|:--------------------------------|
| acfcc                | php artisan config:cache
| acfcl                | php artisan config:clear

#### Common 

| Alias                 | Command                                                                                                                                 |
|:----------------------|:--------------------------------|
|adbs                   |php artisan db:seed
|aeg                    |php artisan event:generate
|akg                    |php artisan key:generate

#### Make

| Alias                 | Command                                                                                                                                 |
|:----------------------|:--------------------------------|
|amkau                  |php artisan make:auth
|amkcm                  |php artisan make:command
|amkct                  |php artisan make:controller
|amkctr                 |php artisan make:controller -r
|amkev                  |php artisan make:event
|amkfc                  |php artisan make:factory
|amkjb                  |php artisan make:job
|amkls                  |php artisan make:listener
|amkml                  |php artisan make:mail
|amkmw                  |php artisan make:middleware
|amkmg                  |php artisan make:migration
|amkmd                  |php artisan make:model
|amkmdm                 |php artisan make:model -m
|amknf                  |php artisan make:notification
|amkpl                  |php artisan make:policy
|amkpv                  |php artisan make:provider
|amkrq                  |php artisan make:request
|amkres                  |php artisan make:resource
|amkrl                  |php artisan make:rule
|amksd                  |php artisan make:seeder
|amkts                  |php artisan make:test

#### Migrate

| Alias                 | Command                                                                                                                                 |
|:----------------------|:--------------------------------|
|amg                    |php artisan migrate
|amgf                   |php artisan migrate --force
|amgs                   |php artisan migrate --seed
|amgp                   |php artisan migrate --pretend
|amgt                   |php artisan migrate --env=testing
|amgfr                  |php artisan migrate:amgfr
|amgis                  |php artisan migrate:install
|amgrf                  |php artisan migrate:refresh
|amgrs                  |php artisan migrate:reset
|amgrb                  |php artisan migrate:rollback
|amgst                  |php artisan migrate:status

#### Notifications

| Alias                 | Command                                                                                                                                 |
|:----------------------|:--------------------------------|
|anftb                   |php artisan notifications:table

#### Package

| Alias                 | Command                                                                                                                                 |
|:----------------------|:--------------------------------|
|apd                   |php artisan package:discover
#### Queue

| Alias                 | Command                                                                                                                                 |
|:----------------------|:--------------------------------|
|aqf                    |php artisan queue:failed
|aqft                   |php artisan queue:failed-table
|aqfl                   |php artisan queue:flush
|aqfg                   |php artisan queue:forget
|aqls                   |php artisan queue:listen
|aqrs                   |php artisan queue:restart
|aqrt                   |php artisan queue:retry
|aqtb                   |php artisan queue:table
|aqwk                   |php artisan queue:work

#### Route

| Alias                 | Command                                                                                                                                 |
|:----------------------|:--------------------------------|
|arcc                   |php artisan route:cache
|arcl                   |php artisan route:clear
|arls                   |php artisan route:list


#### Other

| Alias                 | Command                                                                                                                                 |
|:----------------------|:--------------------------------|
|asrn                   |php artisan schedule:run
|astb                   |php artisan session:table
|asln                   |php artisan storage:link
|avpb                   |php artisan vendor:publish
|avcl                   |php artisan view:clear

#### Laravel 5.2 artisan command aliases

| Alias                 | Command                                                                                                                                 |
|:----------------------|:--------------------------------|
|amkcs                  |php artisan make:console

#### Laravel 5.1 artisan command aliases

| Alias                 | Command                                                                                                                                 |
|:----------------------|:--------------------------------|
|ahcm                   |php artisan handler:command
|ahev                   |php artisan handler:event
|aqss                   |php artisan queue:subscribe

#### Laravel 5.0 artisan command aliases

| Alias                 | Command                                                                                                                                 |
|:----------------------|:--------------------------------|
|afr                    |php artisan fresh
