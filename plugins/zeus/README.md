<<<<<<< HEAD
## zeus
**Maintainer:** [b4mboo](https://github.com/b4mboo)

* `zi` aliases `zeus init`
* `zinit` aliases `zeus init`

* `zs` aliases `zeus start`
* `ztart` aliases `zeus start`

* `zc` aliases `zeus console`
* `zonsole` aliases `zeus console`

* `zsr` aliases `zeus server`
* `zerver` aliases `zeus server`

* `zr` aliases `zeus rake`
* `zake` aliases `zeus rake`

* `zg` aliases `zeus generate`
* `zenerate` aliases `zeus generate`

* `zrn` aliases `zeus runner`
* `zunner` aliases `zeus runner`

* `zcu` aliases `zeus cucumber`
* `zucumber` aliases `zeus cucumber`

* `zspec` aliases `zeus rspec`

* `zt` aliases `zeus test`
* `zest` aliases `zeus test`

* `zu` aliases `zeus test test/unit/*`
* `zunits` aliases `zeus test test/unit/*`

* `zf` aliases `zeus test test/functional/*`
* `zunctional` aliases `zeus test test/functional/*`

* `za` aliases `zeus test test/unit/*; zeus test test/functional/; zeus cucumber`
* `zall` aliases `zeus test test/unit/*; zeus test test/functional/; zeus cucumber`

* `zsw` aliases `rm .zeus.sock`
* `zweep` aliases `rm .zeus.sock`

* `zdbr` aliases `zeus rake db:reset db:test:prepare`
* `zdbreset` aliases `zeus rake db:reset db:test:prepare`

* `zdbm` aliases `zeus rake db:migrate db:test:prepare`
* `zdbmigrate` aliases `zeus rake db:migrate db:test:prepare`

* `zdbc` aliases `zeus rake db:create`

* `zdbcm` aliases `zeus rake db:create db:migrate db:test:prepare`

## Installation
Add zeus to the plugins line of your `.zshconfig` file (e.g. `plugins=(rails git zeus)`)
=======
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
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
