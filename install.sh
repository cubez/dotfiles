#!/usr/bin/env bash

set -e

# Source: https://gist.github.com/davejamesmiller/1965569
ask() {
  while true; do
    if [ "${2:-}" = "Y" ]; then
      prompt="Y/n"
      default=Y
    elif [ "${2:-}" = "N" ]; then
      prompt="y/N"
      default=N
    else
      prompt="y/n"
      default=
    fi
    read -p "$1 [$prompt] " REPLY </dev/tty
    if [ -z "$REPLY" ]; then
      REPLY=$default
    fi
    case "$REPLY" in
      Y*|y*) return 0 ;;
      N*|n*) return 1 ;;
    esac
  done
}

dir=`pwd`

echo "################################################################"
echo "Installation Script"
echo "################################################################"
echo "";
echo "################################################################"
echo "Adding repositories"
echo "################################################################"
sudo add-apt-repository ppa:moka/stable

echo "################################################################"
echo "First update and upgrade"
echo "################################################################"
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -f -y install
sudo apt-get -y upgrade

echo "################################################################"
echo "Install core applications"
echo "################################################################"
sudo apt-get install -y i3
sudo apt-get install -y i3blocks
sudo apt-get install -y git
sudo apt-get install -y vim
sudo apt-get install -y rofi
sudo apt-get install -y compton
sudo apt-get install -y tlp htop fontconfig-infinality --fix-missing

if ask "Install theme, icons and fonts?" Y; then
echo "################################################################"
echo "Install themes"
echo "################################################################"

echo "Arc GTK Theme"
wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_15.10/Release.key
sudo apt-key add - < Release.key
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_15.10/ /' >> /etc/apt/sources.list.d/arc-theme.list"
sudo apt-get update
sudo apt-get install -y arc-theme

echo "Moka Icon Theme"
sudo apt-get install -y moka-icon-theme
fi

echo "################################################################"
echo "Configure"
echo "################################################################"
git config --global user.name "cubez"
git config --global user.email "cubez@cubez.nl"

echo "################################################################"
echo "Setup symlinks for config files"
echo "################################################################"

if ask "Install symlink for .config/fish?" Y; then
  ln -sf ${dir}/.config/fish ${HOME}/.config/fish
fi

if ask "Install symlink for .i3?" Y; then
  ln -sfn ${dir}/.i3 ${HOME}/.i3
fi

if ask "Install symlink for .i3blocks.conf?" Y; then
  ln -sf ${dir}/.i3blocks.conf ${HOME}/.i3blocks.conf
fi

if ask "Install symlink for .gtkrc-2.0?" Y; then
  ln -sf ${dir}/.gtkrc-2.0 ${HOME}/.gtkrc-2.0
fi

if ask "Install symlink for .config/gtk-3.0?" Y; then
  ln -sfn ${dir}/.config/gtk-3.0 ${HOME}/.config/gtk-3.0
fi

if ask "Install symlink for .fonts?" Y; then
  ln -sfn ${dir}/.fonts ${HOME}/.fonts
fi

if ask "Install symlink for .config/compton.conf?" Y; then
  ln -sfn ${dir}/.config/compton.conf ${HOME}/.config/compton.conf
fi

echo "################################################################"
echo "Install extra applications"
echo "################################################################"

if ask "Install Chromium?" Y; then
  sudo apt-get install -y chromium-browser
fi

if ask "Install Spotify?" Y; then
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install -y spotify-client
fi

if ask "Install Dropbox?" Y; then
wget https://linux.dropbox.com/packages/ubuntu/dropbox_2015.10.28_amd64.deb
$ sudo dpkg -i dropbox_2015.10.28_amd64.deb
fi

echo "################################################################"
echo "Extra"
echo "################################################################"

if ask "Install fun terminal stuff?" Y; then
cd ~/Downloads
git clone https://github.com/livibetter/pipes.sh.git
cd pipes.sh
sudo make install
cd ..
git clone https://github.com/livibetter/pipesX.sh.git
cd pipesX.sh
sudo make install
cd ..
git clone https://gist.github.com/5933594.git
mv 5933594 rain.sh
fi