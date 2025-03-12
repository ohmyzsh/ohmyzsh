## Pathfmt plugin

This plugin adds current path information (ex: `~/Downloads/images/...`) into your terminal.

To use it, add `pathfmt` to the plugins array of your zshrc file:
```
plugins=(... pathfmt ...)
```

### Configuration (required)
Add these into your zshrc file:
```
#options = absolute/user/host
PATHFMT_MODE="user"
RPROMPT='$(path_format)'
```

<br>

### Things to Note:
`PATHFMT_MODE` has three modes:
```
1. absolute - full path (from /).
2. user - path from $USER/<path>
3. host - user@machine/<path>
```


Requires [`inetutils`]([url](https://launchpad.net/ubuntu/+source/inetutils)) for the host mode 
> may show: user@unknown when not found & in host mode
