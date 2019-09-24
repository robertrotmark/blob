#!/bin/bash

# Install repo for vim 8
add-apt-repository ppa:jonathonf/vim

# Update repos
apt update

# Install stuff
vim htop mc git i3 shellcheck yamllint zsh fonts-font-awesome dmenu pass mutt moc newsbeuter abook pandoc docker nitrogen urxvt

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install vimplug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -c PlugInstall

# Install patched font on ubuntu
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh

###
git clone ssh://git@git.enokinetwork.com:913/niklas/home-gopass.git ~/.config/gopass
git clone ssh://git@git.enokinetwork.com:913/niklas/home-i3.git ~/.config/i3
git clone ssh://git@git.enokinetwork.com:913/niklas/home-pcmanfm.git ~/.config/pcmanfm
