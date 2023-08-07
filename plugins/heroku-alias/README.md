# heroku-alias
🧬 Full alias for heroku cli

|🚀 last maj|📡 source|
|---|---|
|02/06/2020|[heroku cli doc](https://devcenter.heroku.com/articles/heroku-cli-commands)|

# Alias list

## general
| Alias  | Command |
| ------------- | ------------- |
| h | heroku |
| hauto | heroku autocomplete $(echo $SHELL) |
| hl | heroku local |

## config
| Alias  | Command |
| ------------- | ------------- |
| hc | heroku config |
| hca | heroku config -a |
| hcr | heroku config -r |
| hcs | heroku config:set |
| hcu | heroku config:unset |
| hcfile | function hcfile bellow |

```sh
hcfile() {
  echo " Which platform [-r/a name] ? "
  read platform
  echo " Which file ? "
  read file
  while read line;
    do heroku config:set "$platform" "$line";
  done < "$file"
}
```

## apps and favorites
| Alias  | Command |
| ------------- | ------------- |
| ha | heroku apps |
| hpop | heroku create |
| hkill | heroku apps:destroy |
| hlog | heroku apps:errors |
| hfav | heroku apps:favorites |
| hfava | heroku apps:favorites:add |
| hfavr | heroku apps:favorites:remove |
| hai | heroku apps:info |
| hair | heroku apps:info -r |
| haia | heroku apps:info -a |

# auth
| Alias  | Command |
| ------------- | ------------- |
| h2fa | heroku auth:2fa |
| h2far | heroku auth:2fa:disable |

# access
| Alias  | Command |
| ------------- | ------------- |
| hac | heroku access |
| hacr | heroku access -r |
| haca | heroku access -a |
| hadd | heroku access:add |
| hdel | heroku access:remove |
| hup | heroku access:update |

## addons
| Alias  | Command |
| ------------- | ------------- |
| hads | heroku addons -A |
| hada | heroku addons -a |
| hadr | heroku addons -r |
| hadat | heroku addons:attach |
| hadc | heroku addons:create |
| hadel | heroku addons:destroy |
| hadde | heroku addons:detach |
| hadoc | heroku addons:docs |

## login
| Alias  | Command |
| ------------- | ------------- |
| hin | heroku login |
| hout | heroku logout |
| hi | heroku login -i |
| hwho | heroku auth:whoami |

## authorizations
| Alias  | Command |
| ------------- | ------------- |
| hth | heroku authorizations |
| hthadd | heroku authorizations:create |
| hthif | heroku authorizations:info |
| hthdel | heroku authorizations:revoke |
| hthrot | heroku authorizations:rotate |
| hthup | heroku authorizations:update |

## plugins
| Alias  | Command |
| ------------- | ------------- |
| hp | heroku plugins |

# log
| Alias  | Command |
| ------------- | ------------- |
|hg | heroku logs|
| hgt | heroku log tail |

# database
| Alias  | Command |
| ------------- | ------------- |
| hpg | heroku pg |
| hpsql | heroku pg:psql |
| hpb | heroku pg:backups |
| hpbc | heroku pg:backups:capture |
| hpbd | heroku pg:backups:download |
| hpbr | heroku pg:backups:restore |

# certs
| Alias  | Command |
| ------------- | ------------- |
| hssl | heroku certs |
| hssli | heroku certs:info |
| hssla | heroku certs:add |
| hsslu | heroku certs:update |
| hsslr | heroku certs:remove |
