HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history

dot_bin=~/.zshrc
dot_bin=${dot_bin:A:h}/bin

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
      master|staging)
        out="${2[1]}"
        ;;
      stable)
        out="S"
        ;;
      feature[_/-]*)
        out="f${2#feature}"
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
  PROMPT='%K{23}%F{15} $(__left) %F{23}%k %f'
  RPROMPT='$(__right 23 ${=vcs_info_msg_0_})'

  if [[ -n $SSH_TTY ]]; then
    PROMPT="%K{235}%F{240} ${USER:0:2}@%m %K{23}%F{235}${PROMPT:6}"
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
  if [[ -n $heroku_app && ! "$*" =~ ' --app ' ]]; then
    heroku $* --app $heroku_app
  else
    heroku $*
  fi
}

remote-mongo () {
  if [[ -n $1 ]]; then
    $dot_bin/remote-mongo $*
  else
    $dot_bin/remote-mongo $heroku_app
  fi
}

remote-redis () {
  $dot_bin/remote-redis ${1-$heroku_app}
}

node () {
  if [[ $* == "" ]]; then
    command node --experimental-repl-await -r ~/.noderc
  else
    command node $*
  fi
}

bhead () {
  zparseopts -D -- n:=n
  local opt
  if [[ -n $n ]]; then
    opt=${n[2]}
  else
    opt=10
  fi
  bat -r :$opt $*
}

kubesh () {
  local pod=${1-$(kubectl get pods -o name|fzf)}
  if [[ "$pod" != "" ]]; then
    kubectl exec -ti  $pod -- /bin/sh
  fi
}
alias pods="kubectl get pods"
alias kcl="kubectl"
alias kcx="kubectx"
alias kns="kubens"
alias ks="kubesh"

alias clj="rlwrap java -cp ~/.m2/clojure-current.jar:. clojure.main"

alias dk='docker'
alias dssh='docker-machine ssh'
alias dps='docker ps'
alias dpa='docker ps -a'
alias hcs="he config -s"
alias hl='he logs'
alias hlt='he logs --tail'
alias hsh='he run /bin/bash'
alias hyarn='he run yarn'
alias hnode='he run node --experimental-repl-await'
alias vi=vim

run () {
  if [[ -f mix.exs ]]; then
    iex -S mix phx.server
  elif [[ -f config.ru ]]; then
    bundle exec ruby config.ru
  elif [[ -f package.json ]]; then
    yarn start
  else
    echo "I don't know how to start this application." >&2
  fi
}

dangling () {
  docker $* -f dangling=true
}

gbc () {
  git branch $1
  git checkout $1
}

gru () {
  local remote=${1-origin}
  git remote update $remote
  echo Pruning $remote
  git remote prune $remote
}

gsu () {
  local br=`git rev-parse --abbrev-ref HEAD`
  git branch --set-upstream $br origin/$br
}

alias rmux="tmux -f ~/.tmux/remote.conf -L remote"

ta () {
  local n=${1-Main}
  if tmux has-session -t $n 2>/dev/null; then
    exec tmux a -t $n
  else
    exec tmux new -s ${1-Main}
  fi
}

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
alias gst='git status -sb'
alias pull='git pull'
alias push='git push'

deploy () {
  git push ${1-heroku} $(git branch --show-current):master
}

bindkey -v
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line
setopt noautomenu nobeep

zstyle ':completion:*' completer _expand _complete _files
fpath=(~/.zsh/comp $fpath)
autoload -U zutil compinit complist
compinit

export ERL_AFLAGS="-kernel shell_history enabled"
export PAGER=`which less`
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

. ~/.zshrc.local

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d'

_fzf_complete_mosh () {
  _fzf_complete_ssh $*
}

if [[ "$PATH" != *"node_modules"* ]]; then
  export PATH="$HOME/.local/bin:$PATH:node_modules/.bin"
fi
