. ~/.zshrc.local

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history

dot_bin=~/.zshrc
dot_bin=${dot_bin:A:h}/bin

__collapse_path () {
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

setopt prompt_subst

if [[ -n $TMUX ]]; then
  export TERM=screen-256color
fi

if [[ -n $SSH_TTY ]]; then
  PROMPT='%F{cyan}[%F{yellow}%n@%m %F{blue}$(__collapse_path)%F{cyan}]%f '
  precmd () {
    print -Pn "\e]0;%d - %n@%m\a"
  }
else
  __collapse_branch () {
    local out
    if [[ -n $1 ]]; then
      case $1 in
        master|staging)
          out="%F{green}${1[1]}"
          ;;
        stable)
          out="%F{red}S"
          ;;
        feature[_-]*)
          out="%F{magenta}${1#feature}"
          ;;
        *?)
          out="%F{magenta}$1"
          ;;
      esac
      echo " $out$2"
    fi
  }

  PROMPT='%F{cyan}[%F{blue}$(__collapse_path)$(__collapse_branch ${=vcs_info_msg_0_})${prompt_app}%F{cyan}]%f '
  autoload vcs_info
  zstyle ':vcs_info:*' unstagedstr '%F{11}●'
  zstyle ':vcs_info:*' stagedstr '%F{28}●'
  zstyle ':vcs_info:git*' formats '%b %u%c'
  zstyle ':vcs_info:*' check-for-changes true

  precmd() {
    print -Pn "\e]0;%d\a"
    vcs_info
  }
fi

export PROMPT

app() {
  if [[ -n $1 ]]; then
    prompt_app=$1${2:+-$2}
    heroku_app=$prompt_app
    if [[ $heroku_app =~ -staging$ ]]; then
      prompt_app="${prompt_app%-staging}-s"
    fi
    prompt_app=" %F{yellow}$prompt_app"
  else
    unset heroku_app
    unset prompt_app
  fi
}

he() {
  if [[ -n $heroku_app && ! "$*" =~ ' --app ' ]]; then
    heroku $* --app $heroku_app
  else
    heroku $*
  fi
}

remote-mongo() {
  $dot_bin/remote-mongo ${1-$heroku_app}
}

remote-redis() {
  $dot_bin/remote-redis ${1-$heroku_app}
}

get() {
  curl -b ~/.curl_cookie_jar -c ~/.curl_cookie_jar "$@"
}

post() {
  get -d "$@"
}

put() {
  get -X PUT -d "$@"
}

delete() {
  get -X DELETE "$@"
}

hclone() {
  git clone git@heroku.com:$1.git $2
}

run() {
  local ver=`ruby -e'print RUBY_VERSION'`
  PORT=${1-3000} $dot_bin/poorman ${1-web}
}

con() {
  local ver=`ruby -e'print RUBY_VERSION'`
  if [[ -f script/rails ]]; then
    echo '>>' "Starting Rails 3+ console (Ruby $ver)"
    ruby script/rails c $*
  else
    echo '>>' "Starting Rails 2 console (Ruby $ver)"
    ruby script/console $*
  fi
}

rails() {
  if [[ -f script/rails ]]; then
    ruby script/rails $*
  else
    if [[ $commands[rails] == "/usr/bin/rails" ]]; then
      echo Refusing to use system Rails. >&2
    else
      $commands[rails] $*
    fi
  fi
}

alias be='bundle exec'
alias bu=bundle
alias clj="rlwrap java -cp ~/.jars/clojure-current.jar:. clojure.main"

alias hc="he run 'if [ -f script/console ]; then script/console; else bundle exec rails c; fi'"
alias hcs="he config -s"
alias hl='he logs'
alias hlt='he logs --tail'
alias hrake='he run rake'
alias hrun='he run'
alias hsh='he run /bin/bash'

alias lua="rlwrap luajit -i ~/.luarc"

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

alias g=git
alias ga='git add'
alias gbr='git branch'
alias gci='git commit'
alias gco='git checkout'
alias gdf='git diff'
alias gdfc='git diff --cached'
alias ghi='git log -p'
alias glog='git log'
alias gst='git status -sb'
alias pull='git pull'
alias push='git push'
alias deploy='git push heroku stable:master'
alias stage='git push heroku staging:master'

bindkey -v
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line
bindkey "^R" history-incremental-search-backward
setopt noautomenu nobeep

zstyle ':completion:*' completer _expand _complete _files
fpath=(~/.zsh/comp $fpath)
autoload -U zutil compinit complist
compinit

export PATH="$HOME/bin:$HOME/.heroku/heroku-client/bin:$PATH"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
