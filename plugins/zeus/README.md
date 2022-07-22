# zeus plugin

[Zeus](https://github.com/burke/zeus) preloads your Rails environment and forks that
process whenever needed. This effectively speeds up Rails' boot process to under 1 sec.
This plugin adds autocompletion for zeus and aliases for common usage.

To use it, add `zeus` to the plugins array in your zshrc file:

```zsh
plugins=(... zeus)
```

You also need to have the `zeus` gem installed.

| Alias        | Command                                                            |
|:-------------|:-------------------------------------------------------------------|
| _zi_         | `zeus init`                                                        |
| _zinit_      | `zeus init`                                                        |
| _zs_         | `zeus start`                                                       |
| _ztart_      | `zeus start`                                                       |
| _zc_         | `zeus console`                                                     |
| _zonsole_    | `zeus console`                                                     |
| _zsr_        | `zeus server`                                                      |
| _zerver_     | `zeus server`                                                      |
| _zr_         | `noglob zeus rake`                                                 |
| _zake_       | `noglob zeus rake`                                                 |
| _zg_         | `zeus generate`                                                    |
| _zenerate_   | `zeus generate`                                                    |
| _zrn_        | `zeus runner`                                                      |
| _zunner_     | `zeus runner`                                                      |
| _zcu_        | `zeus cucumber`                                                    |
| _zucumber_   | `zeus cucumber`                                                    |
| _zwip_       | `zeus cucumber --profile wip`                                      |
| _zspec_      | `zeus rspec`                                                       |
| _zt_         | `zeus test`                                                        |
| _zest_       | `zeus test`                                                        |
| _zu_         | `zeus test test/unit/*`                                            |
| _zunits_     | `zeus test test/unit/*`                                            |
| _zf_         | `zeus test test/functional/*`                                      |
| _zunctional_ | `zeus test test/functional/*`                                      |
| _za_         | `zeus test test/unit/*; zeus test test/functional/; zeus cucumber` |
| _zall_       | `zeus test test/unit/*; zeus test test/functional/; zeus cucumber` |
| _zsw_        | `rm .zeus.sock`                                                    |
| _zweep_      | `rm .zeus.sock`                                                    |
| _zdbr_       | `zeus rake db:reset db:test:prepare`                               |
| _zdbreset_   | `zeus rake db:reset db:test:prepare`                               |
| _zdbm_       | `zeus rake db:migrate db:test:prepare`                             |
| _zdbmigrate_ | `zeus rake db:migrate db:test:prepare`                             |
| _zdbc_       | `zeus rake db:create`                                              |
| _zdbcm_      | `zeus rake db:create db:migrate db:test:prepare`                   |
