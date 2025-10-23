#!/usr/bin/env zsh

vim_dir="$HOME/.vim"
upgrade="| PlugUpgrade "

for vim in nvim vim; do
  if whence -p $vim >/dev/null; then
    echo "Updating plugins in $vim"
    $vim -u NONE -c "so $vim_dir/autoload/plug.vim | so $vim_dir/plugins.vim $upgrade| PlugUpdate | qa"
    upgrade=''
  fi
done
