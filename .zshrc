HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history

setopt prompt_subst
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
disable r

_prompt_bg=8
_prompt_fg=15
_prompt_bg2=235
_prompt_fg2=243

__left () {
  case $PWD in
    $HOME/*)
      echo ${PWD#$HOME/}
      ;;
    $HOME)
      echo '~'
      ;;
    *)
      echo $PWD
      ;;
  esac
}

__right () {
  local out bar
  bar=()
  if [[ -n $heroku_app ]]; then
    bar+=$heroku_app
  fi

  if [[ -n $2 ]]; then
    case $2 in
      main|master|staging)
        out="${2[1]}"
        ;;
      stable)
        out="S"
        ;;
      feature[_/-]*)
        out="f${2#feature}"
        ;;
      issue-*)
        out="#${2#issue-}"
        ;;
      *?)
        out="$2"
        ;;
    esac
    bar+=" $3$out"
  fi

  if [[ -n $bar[1] ]]; then
    echo "%F{$1} ${(j:  :)bar} "
  fi
}

autoload vcs_info
zstyle ':vcs_info:*' unstagedstr '%F{160}'
zstyle ':vcs_info:*' stagedstr '%F{178}'
zstyle ':vcs_info:git*' formats '%b %u%c'
zstyle ':vcs_info:*' check-for-changes true
precmd () { vcs_info }

if [[ $TERM == linux ]]; then
  PROMPT='%F{cyan} $(__left) %B$ %f'
  if [[ -n $SSH_TTY ]]; then
    PROMPT="%F{blue} ${USER:0:2}@%m$PROMPT"
  fi
else
  PROMPT="%K{$_prompt_bg}%F{$_prompt_fg} \$(__left) %F{$_prompt_bg}%k %f"
  RPROMPT="\$(__right $_prompt_bg \${=vcs_info_msg_0_})"

  if [[ -n $SSH_TTY ]]; then
    PROMPT="%K{$_prompt_bg2}%F{$_prompt_fg2} ${USER:0:2}@%m %F{$_prompt_bg2}%K{$_prompt_bg}$(echo $PROMPT|sed -E 's/^[^}]}//')"
  fi
fi

app () {
  if [[ -n $1 ]]; then
    heroku_app=$1${2:+-$2}
  else
    unset heroku_app
  fi
}

he () {
  if [[ $1 == "help" ]]; then
    heroku $*
  else
    if [[ -n $heroku_app && ! "$*" =~ ' --app ' ]]; then
      heroku $* --app $heroku_app
    else
      heroku $*
    fi
  fi
}

kpwd () {
  echo $(kubectx -c) '>' $(kubens -c)
}

ky () {
  kubectl get $* -o yaml|bat -l yaml
}

dj () {
  docker inspect $*|bat -l json
}

clone () {
  git clone git@github.com:$1.git $2
}

autoload activate clip dangling kubesh ta conda

alias l='eza --group-directories-first'
alias L='l -l'
alias la='l -a'
alias La='l -al'

alias be='bundle exec'
alias bu='bundle'
alias rails='bundle exec rails'
alias rake='bundle exec rake'

alias bat='bat -p'
alias batn='\bat'
alias yat='bat -lyaml'
alias yatn='batn -lyaml'

jat () {
  jq . $*|bat -ljson
}

jatn () {
  jq . $*|batn -ljson
}

help () {
  $1 --help|bat -lhelp
}

alias pods="kubectl get pods"
alias kup="kubectl apply -f"
alias kcl="kubectl"
alias kcx="kubectx"
alias kg="kubectl get"
alias kgd="kubectl get deploy"
alias kd="kubectl describe"
alias kns="kubens"
alias ks="kubesh"
alias kcp="kubectl cp"

alias dssh='docker-machine ssh'
alias di='docker image ls'
alias dv='docker volume ls'
alias dps='docker ps'
alias dpa='docker ps -a'

alias apps="heroku apps -A"
alias hcs="he config -s"
alias hsh='he run /bin/bash'
alias hrc='he run env PAGER=cat rails c'

alias ts-node='npx ts-node'

alias rmux="tmux -f ~/.tmux/remote.conf -L remote"

gbs () {
  if [[ -n $1 ]]; then
    git switch $1
  else
    git branch --list|fzf|sed 's/^[ *]*//'|xargs git switch
  fi
}

alias g=git
alias ga='git add'
alias gbc='git switch -c'
alias gbr='git branch'
alias gci='git commit'
alias gco='git checkout'
alias gdf='git diff'
alias gdfc='git diff --cached'
alias gdfn='git diff --name-status'
alias ghi='git log -p --no-textconv'
alias glog='git log --stat'
alias grv='git remote -v'
alias gst='git status -sb'

alias ours='git checkout --ours'
alias theirs='git checkout --theirs'

alias amend='git commit --amend'
alias merge='git merge'
alias fetch='git fetch'
alias prune='git fetch --prune'
alias rebase='git rebase'
alias pull='git pull'
alias push='git push'
alias show='git show'

bindkey -v
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line
setopt noautomenu nobeep hist_ignore_space

function zle-line-init () {
  print -n "\e[?1000l"
  zle-keymap-select
}
function zle-keymap-select () {
  case $KEYMAP in
    vicmd) print -n -- "\e[2 q";;
    viins|main) print -n -- "\e[6 q";;
  esac
}

function zle-line-finish () {
  print -n -- "\e[2 q"
}

zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish

zstyle ':completion:*' completer _expand _complete _files
fpath=(~/.local/share/zsh/functions ~/.zsh/functions $fpath)
autoload -U zutil complist compinit

export ERL_AFLAGS="-kernel shell_history enabled"
export BAT_THEME=ansi
export PAGER='bat -p'
export DELTA_PAGER=$PAGER
export MANPAGER="sh -c 'col -bx | bat -lman -p'"
export MANROFFOPT='-c'

. ~/.zshrc.local

# Heroku goes a bit too far, let's undo some of its stuff.
if type expand-or-complete-with-dots >/dev/null; then
  bindkey -r "^I"
  zle -D expand-or-complete-with-dots
  unset -f expand-or-complete-with-dots
fi

if `command -v nvim >/dev/null`; then
  export EDITOR=nvim
  alias vim=nvim
else
  export EDITOR=vim
fi

type fzf >/dev/null 2>&1 && source <(fzf --zsh)

type compdef >/dev/null || compinit
compdef _docker dangling
compdef _heroku he

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d'
export FZF_DEFAULT_OPTS='--color=fg+:15,preview-fg:15'

_fzf_complete_mosh () {
  _fzf_complete_ssh $*
}

if [[ "$PATH" != *".local"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

if [[ -d .ghcup && "$PATH" != *"ghcup"* ]]; then
  export PATH="$HOME/.ghcup/bin:$PATH"
fi

if [[ -d .cargo && "$PATH" != *"cargo"* ]]; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi
