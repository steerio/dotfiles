#!/usr/bin/env zsh

cd $(dirname $0)/.vim/pack/plugins
for i in */*; do
  cd $i
  echo '>>>' Checking $i
  [[ -d .git ]] && git pull
  cd -
done
