. ~/.zshrc.local

ANDROID_HOME=$HOME/Android
BREW=$HOME/.brew
EDITOR=$HOME/bin/vim # MacVim
JAVA_HOME=`echo /Library/Java/JavaVirtualMachines/*1.7.0*/Contents/Home`
LSCOLORS=cx
LUA_PATH="$BREW/share/lua/5.1/?.lua;$BREW/share/lua/5.1/?/init.lua;$HOME/.luarocks/share/lua/5.1/?.lua;$HOME/.luarocks/share/lua/5.1/?/init.lua;$BREW/Cellar/luarocks/2.0.12/share/lua/5.1/?.lua;$BREW/Cellar/luarocks/2.0.12/share/lua/5.1/?/init.lua;$BREW/share/lua/5.1/?.lua;$BREW/share/lua/5.1/?/init.lua;$HOME/.luarocks/share/lua/5.1/?.lua;$HOME/.luarocks/share/lua/5.1/?/init.lua;$BREW/Cellar/luarocks/2.0.10/share/lua/5.1/?.lua;$BREW/Cellar/luarocks/2.0.10/share/lua/5.1/?/init.lua;./?.lua;$BREW/Cellar/luajit/2.0.0/share/luajit-2.0.0/?.lua;$BREW/Cellar/luajit/2.0.0/share/lua/5.1/?.lua;$BREW/Cellar/luajit/2.0.0/share/lua/5.1/?/init.lua;;$LUA_PATH"
LUA_CPATH="$BREW/lib/lua/5.1/?.so;$HOME/.luarocks/lib/lua/5.1/?.so;$BREW/lib/lua/5.1/?.so;$HOME/.luarocks/lib/lua/5.1/?.so;./?.so;$BREW/Cellar/luajit/2.0.0/lib/lua/5.1/?.so;;$LUA_CPATH"
PATH=$HOME/bin:$BREW/bin:$HOME/.rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history

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

if [[ -n $SSH_TTY ]]; then
  PROMPT="%F{green}%n@%m %F{blue}%~ %#%f "
else
  PROMPT='%F{cyan}[%F{blue}%~$(__collapse_branch ${=vcs_info_msg_0_})%F{cyan}]%f '
  autoload vcs_info
  setopt prompt_subst
  zstyle ':vcs_info:*' unstagedstr '%F{11}●'
  zstyle ':vcs_info:*' stagedstr '%F{28}●'
  zstyle ':vcs_info:git*' formats '%b %u%c'
  zstyle ':vcs_info:*' check-for-changes true

  precmd() {
    vcs_info
  }
fi

export ANDROID_HOME BREW EDITOR JAVA_HOME LSCOLORS \
       LUA_CPATH LUA_PATH PATH PROMPT

app() {
  if [[ $1 == . ]]; then
    heroku_app=$(basename `pwd`)
    [[ -n $2 ]] && heroku_app+="-$2"
  else
    heroku_app=$1
  fi

  if [[ -n $heroku_app ]]; then
    if [[ $heroku_app =~ -staging$ ]]; then
      RPROMPT="%F{red}${heroku_app%-staging}%F{magenta}-s%f"
    else
      RPROMPT="%F{red}$heroku_app%f"
    fi
  else
    unset heroku_app
    unset RPROMPT
  fi
}

heroku() {
  if [[ -n $heroku_app && ! "$*" =~ ' --app ' ]]; then
    $commands[heroku] $* --app $heroku_app
  else
    $commands[heroku] $*
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
  echo -n "Repo $github_company/$1: "
  git clone git@github.com:$github_company/$1 "$n"
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
alias clj='rlwrap java -cp ~/jars/clojure-1.5.0.jar:. clojure.main'
alias he=heroku

alias hc="heroku run 'if [ -f script/console ]; then script/console; else bundle exec rails c; fi'"
alias hdump='heroku pgbackups:capture'
alias hl='heroku logs'
alias hrake='heroku run rake'
alias hrestore='heroku pgbackups:restore'
alias hrun='heroku run'
alias hsh='heroku run /bin/bash'

alias ls='ls -G'
alias lua="rlwrap luajit -i ~/.luarc"

alias br='git branch'
alias co='git checkout'
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
