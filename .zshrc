. ~/.zshrc.local

ANDROID_HOME=$HOME/Android
LSCOLORS=cx

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history

if [[ -n $SSH_TTY ]]; then
  PROMPT="%F{cyan}[%F{yellow}%n@%m %F{blue}%~%F{cyan}]%f "
  precmd () {
    print -Pn "\e]0;%d - %n@%m\a"
  }
else
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
  setopt prompt_subst
  zstyle ':vcs_info:*' unstagedstr '%F{11}●'
  zstyle ':vcs_info:*' stagedstr '%F{28}●'
  zstyle ':vcs_info:git*' formats '%b %u%c'
  zstyle ':vcs_info:*' check-for-changes true

  precmd() {
    print -Pn "\e]0;%d\a"
    vcs_info
  }
fi

export ANDROID_HOME LSCOLORS PATH PROMPT

app() {
  if [[ -n $1 ]]; then
    prompt_app=$1${2:+-$2}
    heroku_app=$prompt_app
    if [[ $heroku_app =~ ^pillango- ]]; then
      prompt_app="p-${prompt_app#pillango-}"
    fi
    if [[ $heroku_app =~ -staging$ ]]; then
      prompt_app="${prompt_app%-staging}-s"
    fi
    prompt_app=" %F{yellow}$prompt_app"
  else
    unset heroku_app
    unset prompt_app
  fi
}

heroku() {
  if [[ -n $heroku_app && ! "$*" =~ ' --app ' ]]; then
    ~/.heroku/client/bin/heroku $* --app $heroku_app
  else
    ~/.heroku/client/bin/heroku $*
  fi
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

clone() {
  if [[ -n $2 ]]; then
    n=$2
  else
    n=${1%-server}
  fi
  local repo="git@github.com:$github_company/$1.git"
  echo "Repository $repo"
  git clone $repo $n
}

hclone() {
  git clone git@heroku.com:$1.git $2
}

ec2() {
  ssh -i $ec2_keyfile root@$1
}

run() {
  local ver=`ruby -e'print RUBY_VERSION'`
  if [[ -f Gemfile ]]; then
    if `grep -q unicorn Gemfile`; then
      echo '>>' "Unicorn with bundler (Ruby $ver)"
      bundle exec unicorn -p 3000 $*
    else
      echo '>>' "Thin with bundler (Ruby $ver)"
      bundle exec thin $* start
    fi
  else
    echo '>>' "Thin (Ruby $ver)"
    thin $* start
  fi
}

con() {
  local ver=`ruby -e'print RUBY_VERSION'`
  if [[ -f script/rails ]]; then
    echo '>>' "Starting Rails 3 console (Ruby $ver)"
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
alias clj="rlwrap java -cp ~/jars/clojure-current.jar:. clojure.main"
alias he=heroku

alias hc="heroku run 'if [ -f script/console ]; then script/console; else bundle exec rails c; fi'"
alias hl='heroku logs'
alias hlt='heroku logs --tail'
alias hrake='heroku run rake'
alias hrun='heroku run'
alias hsh='heroku run /bin/bash'

alias ls='ls -G'
alias lua="rlwrap luajit -i ~/.luarc"

gbc () {
  git branch $1
  git checkout $1
}

alias g=git
alias ga='git add'
alias gbr='git branch'
alias gci='git commit'
alias gco='git checkout'
alias gdf='git diff'
alias gdfc='git diff --cached'
alias ghi='git log -p'
alias glog='git log'
alias grp='git remote prune'
alias gru='git remote update'
alias gst='git status -sb'
alias pull='git pull'
alias push='git push'

bindkey -v
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line
bindkey "^R" history-incremental-search-backward
setopt noautomenu nobeep

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

zstyle ':completion:*' completer _expand _complete _files
fpath=(~/.zsh/comp $fpath)
autoload -U zutil compinit complist
compinit
