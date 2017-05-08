#!/bin/zsh

system=${$(uname):l}

if [[ -z $ZSH_VERSION ]]; then
  echo 'This script needs zsh.' >&2
  exit 1
fi

setopt extended_glob

cd `dirname $0`
src=${$(pwd)#$HOME/}

# Linking all dotfiles/dotfolders

for i in (.*~.git*~.*.swp); do
  echo "Linking $i"
  rm -rf $HOME/$i
  ln -s $src/$i $HOME/
done

# Set up tmux

tmux=$HOME/.tmux.conf
rm -f $tmux
echo 'Linking tmux configuration'
if [[ -f .tmux/$system.conf ]]; then
  ln -s .tmux/$system.conf $tmux
else
  ln -s .tmux/common.conf $tmux
fi

# Set up zsh

echo 'Setting up local zshrc'
if [[ ! -f $HOME/.zshrc.local ]]; then
  echo . $HOME/.zsh/$system > $HOME/.zshrc.local
fi

# Heroku completion

ruby scrape-heroku.rb >.zsh/comp/_he
