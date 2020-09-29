#!/bin/zsh

root='.vim/pack/plugins'
cd $root

process () {
  cd $1
  for i in */.git; do
    cd $(dirname $i)
    echo git clone $(git remote get-url origin)
    cd ..
  done
  cd ..
}

echo '#!/bin/zsh'
echo "mkdir -p ~/$root/{start,opt}"
echo "cd ~/$root/start"
process start
echo "cd ../opt"
process opt
