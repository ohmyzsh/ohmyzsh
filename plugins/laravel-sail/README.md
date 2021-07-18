# laravel-sail plugin

This plugin adds aliases for laravel [sail](https://laravel.com/docs/sail) cli tool 

```
plugins=(... laravel-sail)
```

## Usage

### General
| Alias | Description |
|:-:|:-:|
| `s`  |  `sail` |
| `sup`  |  `sail up` |
| `sud`  |  `sail up -d` |
| `sdown`  |  `sail down` |
|`sb`|`sail build`|

### artisan and Dependencies 
| Alias | Description |
|:-:|:-:|
| `sa`  |  `sail artisan` |
|`sp`|`sail php`|
|`sc`|`sail composer`|
|`sn`|`sail npm`|

### npm build commands
| Alias | Description |
|:-:|:-:|
|`swatch`|`sail npm run watch`|
|`sdev`|`sail npm run dev`|
|`sprod`|`sail npm run production`|

### Testing
| Alias | Description |
|:-:|:-:|
|`st`|`sail test`|
|`sdusk`|`sail dusk`|

### Others
| Alias | Description |
|:-:|:-:|
|`sh`|`sail shell`|
|`stinker`|`sail tinker`|
|`sshare`|`sail share`|
