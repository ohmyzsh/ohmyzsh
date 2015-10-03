# Branch

Displays the current Git or Mercurial branch fast.

## Speed test

### Mercurial

```shell
$ time hg branch
0.11s user 0.14s system 70% cpu 0.355 total
```

### Branch plugin

```shell
$ time sh /tmp/branch_prompt_info.sh
0.01s user 0.01s system 81% cpu 0.018 total
```

## Usage

Edit your theme file (eg.: `~/.oh-my-zsh/theme/robbyrussell.zsh-theme`) 
adding `$(branch_prompt_info)` in your prompt like this:

```diff
- PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
+ PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)$(branch_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
```

## Maintainer

Victor Torres (<vpaivatorres@gmail.com>)
