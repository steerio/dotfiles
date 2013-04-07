#!/bin/zsh

if [[ -z $ZSH_VERSION ]]; then
  echo This script needs zsh. >&2
fi

setopt extended_glob

cd `dirname $0`
src=${$(pwd)#$HOME/}

for i in (.*~.git*~.*.swp); do
  echo Linking $i
  rm -rf $HOME/$i
  ln -s $src/$i $HOME/
done
