##
# Developed by NETPUNK#, software services
# http://www.netpunk.net (not up ATM)
#
# License: MIT
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
##

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo 'GIT ☢ ↪' && return
    hg root >/dev/null 2>/dev/null && echo 'HG ☢ ↪' && return
    echo ' ☢ ↪'
}
function battery_charge {
    if [ -e /usr/local/bin/batcharge.py ]
    then
        echo `python /usr/local/bin/batcharge.py`
    else
        echo '';
    fi
}

function hg_prompt_info {
  if [ $(in_hg) ]; then
    hg prompt "{rev}:{node|short} on {root|basename}/{branch} {task} {status} {update} {patch|count|unapplied} {incoming changes{incoming}} " 2>/dev/null
  fi
}
if which rvm-prompt &> /dev/null; then
  PROMPT='%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%} %~ %{$reset_color%}$(hg_prompt_info)$(git_prompt_info)%{$reset_color%}
   $(prompt_char)  '
  RPROMPT='%{$fg[red]%}RB $(~/.rvm/bin/rvm-prompt)%{$reset_color%}  %{$fg[magenta]%}$(date "+%Y-%m-%d")%{$reset_color%} %{$fg[green]%} BAT: %{$reset_color%} $(battery_charge)'
elif which rbenv &> /dev/null; then
  PROMPT='%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%} %~ %{$reset_color%}$(hg_prompt_info)$(git_prompt_info)%{$reset_color%}
   $(prompt_char)  '
  RPROMPT='%{$fg[red]%}RB $(rbenv version | sed -e "s/ (set.*$//")%{$reset_color%} %{$fg[magenta]%}$(date "+%Y-%m-%d")%{$reset_color%} %{$fg[green]%} BAT: %{$reset_color%} $(battery_charge)'

fi

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[white]%}%{$bg[red]%} ✖ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}%{$bg[magenta]%} ◘ "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✔ "
