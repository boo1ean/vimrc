#!/usr/bin/env bash

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

cd $HOME
VIM_HOME=$HOME/.config/nvim
I3_HOME=$HOME/.config/i3

# install system-wide stuff
apt update
apt install -y software-properties-common
add-apt-repository ppa:neovim-ppa/stable

apt update
apt install -y \
	python3.5 \
	neovim \
	zsh \
	git \
	silversearcher-ag \
	make \
	g++ \
	i3 \
	docker.io \

curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
python3.5 get-pip.py
rm get-pip.py

# install configs
git clone https://github.com/boo1ean/dotfiles.git

# setup vim
mkdir -p $VIM_HOME/undodir
mkdir $VIM_HOME/colors
mv dotfiles/.config/nvim/colors/wombat256.vim $VIM_HOME/colors/
mv dotfiles/.config/nvim/init.vim $VIM_HOME/
git clone https://github.com/VundleVim/Vundle.vim.git $VIM_HOME/bundle/Vundle.vim
nvim +PluginInstall +qall

# setup i3
mkdir -p $I3_HOME
mv dotfiles/i3/* $I3_HOME/

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install node version manager
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
[ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"

# copy dotfiles
mv dotfiles/.aliases   ./
mv dotfiles/.gitconfig ./
mv dotfiles/.zshrc     ./
mv dotfiles/.env       ./
mv dotfiles/.z.sh      ./
rm -rf dotfiles

chown $SUDO_USER:$SUDO_USER -R ./
