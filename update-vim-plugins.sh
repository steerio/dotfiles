#!/usr/bin/env zsh

cd ~/.vim
for i in $(find pack vim8 nvim -name .git -type d); do
  folder=`dirname $i`
  echo '>>>' Checking $folder
  cd $folder
  git pull
  if [[ -f yarn.lock ]]; then
    yarn install
  else
    [[ -f package-lock.json ]] && npm install
  fi
  cd -
done
