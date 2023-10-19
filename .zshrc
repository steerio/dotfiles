HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history

scripts=~/.zshrc
scripts=${scripts:A:h}/scripts

setopt prompt_subst
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
disable r

if [[ -n $TMUX ]]; then
  export TERM=screen-256color
fi

. ~/.zshrc.theme

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

remote-mongo () {
  if [[ -n $1 ]]; then
    $scripts/remote-mongo $*
  else
    $scripts/remote-mongo $heroku_app
  fi
}

node () {
  if [[ $* == "" ]]; then
    command node -r ~/.noderc
  else
    command node $*
  fi
}

kpwd () {
  echo $(kubectx -c) '>' $(kubens -c)
}

ky () {
  kubectl get $* -o yaml|bat -l yaml
}

djson () {
  docker inspect $*|bat -l json
}

deploy () {
  git push ${1-heroku} $(git branch --show-current):master
}

autoload bhead clip dangling gru kubesh ta

alias l='eza --group-directories-first'
alias L='l -l'
alias la='l -a'
alias La='l -al'

alias be='bundle exec'
alias bu='bundle'
alias rails='bundle exec rails'
alias rake='bundle exec rake'

alias byaml="bat -l yaml"
alias bjson="bat -l json"

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
alias kyd="ky deploy"

alias clj="rlwrap java -cp ~/.m2/clojure-current.jar:. clojure.main"

alias dssh='docker-machine ssh'
alias di='docker image ls'
alias dv='docker volume ls'
alias dps='docker ps'
alias dpa='docker ps -a'
alias drmi='docker rmi'
alias drm='docker rm'

alias apps="heroku apps -A"
alias hcs="he config -s"
alias hl='he logs'
alias hlt='he logs --tail'
alias hsh='he run /bin/bash'
alias hyarn='he run yarn'
alias hnode='he run node --experimental-repl-await'

alias ts-node='npx ts-node'
alias gbc='git checkout -b'

alias rmux="tmux -f ~/.tmux/remote.conf -L remote"

alias g=git
alias ga='git add'
alias gbr='git branch'
alias gci='git commit'
alias gco='git checkout'
alias gdf='git diff'
alias gdfc='git diff --cached'
alias ghi='git log -p'
alias glg='git log --graph'
alias glog='git log --stat'
alias grv='git remote -v'
alias gst='git status -sb'
alias merge='git merge'
alias fetch='git fetch'
alias pull='git pull'
alias push='git push'

bindkey -v
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line
setopt noautomenu nobeep

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
fpath=(~/.local/share/zsh/functions ~/.zsh/functions ~/.asdf/completions $fpath)
autoload -U zutil complist compinit

export ERL_AFLAGS="-kernel shell_history enabled"
export PAGER=`which less`
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

. ~/.zshrc.local

type compdef >/dev/null || compinit
compdef _docker dangling
compdef _heroku he

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d'

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
  export PATH="$HOME/.cargo/bin:$PATH"
fi

if [[ -d .asdf ]]; then
  export ASDF_DIR=$HOME/.asdf
  if [[ "$PATH" != *".asdf/bin"* ]]; then
    export PATH=$ASDF_DIR/bin:$PATH
  fi
  if [[ "$PATH" != *".asdf/shims"* ]]; then
    export PATH=$ASDF_DIR/shims:$PATH
  fi
fi
