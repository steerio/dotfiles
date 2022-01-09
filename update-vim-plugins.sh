#!/usr/bin/env zsh

cd $(dirname $0)/.vim/pack/plugins
for i in */*; do
  cd $i
  echo '>>>' Checking $i
  if [[ -d .git ]]; then
    git pull
    if [[ -f yarn.lock ]]; then
      yarn install
    else
      [[ -f package-lock.json ]] && npm install
    fi
  fi
  cd -
done
