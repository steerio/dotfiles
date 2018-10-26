. ~/.zshrc.local

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history

dot_bin=~/.zshrc
dot_bin=${dot_bin:A:h}/bin

setopt prompt_subst

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
      feature[_-]*)
        out="${2#feature}"
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

PROMPT='%K{23}%F{15} $(__left) %F{23}%k %f'
RPROMPT='$(__right 23 ${=vcs_info_msg_0_})'

if [[ -n $SSH_TTY ]]; then
  PROMPT="%K{235}%F{240} ${USER:0:2}@%m %K{23}%F{235}${PROMPT:6}"
fi

export PROMPT RPROMPT

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

load () {
  for i in `grep -v '^#' $1`; do
    export $i
  done
}

remote-mongo () {
  $dot_bin/remote-mongo ${1-$heroku_app}
}

remote-redis () {
  $dot_bin/remote-redis ${1-$heroku_app}
}

run () {
  PORT=${PORT-3000} $dot_bin/poorman ${1-web}
}

alias be='bundle exec'
alias bu=bundle
alias clj="rlwrap java -cp ~/.m2/clojure-current.jar:. clojure.main"
alias node="node -r ~/.noderc"

alias dssh='docker-machine ssh'
alias dps='docker ps'
alias hcs="he config -s"
alias hl='he logs'
alias hlt='he logs --tail'
alias hrun='he run'
alias hsh='he run /bin/bash'

alias egrep='egrep --color=auto'
alias rgrep='egrep -r'
ngrep () {
  egrep -r --exclude-dir=node_modules $*
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
alias glog='git log'
alias gst='git status -sb'
alias pull='git pull'
alias push='git push'
alias deploy='git push heroku stable:master'
alias stage='git push staging staging:master'

bindkey -v
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line
bindkey "^R" history-incremental-search-backward
setopt noautomenu nobeep

zstyle ':completion:*' completer _expand _complete _files
fpath=(~/.zsh/comp $fpath)
autoload -U zutil compinit complist
compinit

if [[ "$PATH" != *"yarn"* ]]; then
  export PATH="$HOME/.local/bin:$PATH:node_modules/.bin:$HOME/.yarn/bin"
fi

# First line sets the PATH, let's prefix it with a conditional:
eval "[[ -z \$RBENV_SHELL ]] && $(rbenv init - 2>/dev/null)"
