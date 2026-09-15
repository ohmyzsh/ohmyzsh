```markdown
# Magento 2

This plugin adds aliases for Magento2 commands.

```bash
plugins=(... magento2)
```

| Alias    | Description                                          |
|:-:|:-:|
| `magento`| `bin/magento`                                       |
| `mup`   | `bin/magento setup:upgrade`                         |
| `mdeploy`   | `bin/magento setup:static-content:deploy -f`        |
| `mdi`   | `bin/magento setup:di:compile`                      |

## Database

| Alias      | Description                       |
|:-:|:-:|
| `mreindex` | `bin/magento indexer:reindex`     |
| `minf`     | `bin/magento indexer:info`        |
| `mid`      | `bin/magento indexer:disable`     |
| `mien`     | `bin/magento indexer:enable`      |

## Maintenance

| Alias | Description                       |
|:-:|:-:|
| `mmt` | `bin/magento maintenance:enable`  |
| `mmf` | `bin/magento maintenance:disable` |

## Clears

| Alias   | Description                                          |
|:-:|:-:|
| `mcc`   | `bin/magento cache:clean`                           |
| `mcf`   | `bin/magento cache:flush`                           |
| `mtcc`  | `bin/magento cache:clean`                           |
| `mtcf`  | `bin/magento cache:flush`                           |
| `mtccf` | `bin/magento cache:flush && bin/magento cache:clean` |

## Admin

| Alias | Description                        |
|:-:|:-:|
| `mac` | `bin/magento bin\magento a:u:c` |
| `mau` | `bin/magento bin\magento a:u:u` |
| `maurl` | `bin/magento bin\magento i:a` |

## Queues

| Alias | Description                           |
|:-:|:-:|
| `mqs` | `bin/magento queue:consumers:start`   |

## Logs

| Alias    | Description                                                                                           |
|:-:|:-:|
| `mlog`| `tail -f var/log/*.log` |
| `mslog`| `tail -f var/log/system.log` |
| `melog`| `tail -f var/log/exeption.log` |

## Development

| Alias   | Description                                          |
|:-:|:-:|
| `mms`   | `'bin\magento module:status`                           |
| `mme`   | `'bin\magento module:enable`                           |
| `mmd`   | `'bin\magento module:disable`                           |

```