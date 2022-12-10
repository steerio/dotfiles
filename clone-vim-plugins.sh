#!/usr/bin/env zsh

cd `dirname $0`/.vim

echo '#!/usr/bin/env zsh'
echo "mkdir -p ~/.vim; cd ~/.vim"

prev=''

for i in $(find pack nvim vim90 -name .git -type d|sort); do
  folder=`dirname $i`
  name=`basename $folder`
  parent=`dirname $folder`
  if [[ $prev != $parent ]]; then
    [[ -n $prev ]] && echo "cd -"
    echo "mkdir -p $parent; cd $parent"
  fi
  prev=$parent
  echo "git clone $(git --git-dir=$i remote get-url origin) $name"
done
