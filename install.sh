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
echo "First update and upgrade"
echo "################################################################"
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -f -y install
sudo apt-get -y upgrade

echo "################################################################"
echo "Install core applications"
echo "################################################################"
sudo apt-get install -y i3 vim conky rofi compton feh
sudo apt-get install -y tlp htop --fix-missing

echo "Setting symlinks for i3, conky, xresources and compton"
ln -sfn ${dir}/.i3 ${HOME}/.i3
ln -sf ${dir}/.conkyrc ${HOME}/.conkyrc
ln -sfn ${dir}/.Xresources ${HOME}/.Xresources
ln -sfn ${dir}/.config/compton.conf ${HOME}/.config/compton.conf

if ask "Set fish as default shell?" Y; then
sudo apt-get install -y fish
chsh -s /usr/bin/fish

echo "Setting symlinks for fish"
mkdir -p ${HOME}/.config/fish
ln -sf ${dir}/.config/fish/config.fish ${HOME}/.config/fish/config.fish
fi

echo "################################################################"
echo "Customization"
echo "################################################################"

if ask "Install Arc GTK and Moka Icon Theme?" Y; then
# Arc GTK Theme
sudo wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_15.10/Release.key
sudo apt-key add - < Release.key
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_15.10/ /' >> /etc/apt/sources.list.d/arc-theme.list"

# Moka Icon Theme
sudo add-apt-repository -y ppa:moka/stable

sudo apt-get update
sudo apt-get install -y arc-theme moka-icon-theme

echo "Setting symlinks for gtkrc and fonts";
ln -sf ${dir}/.gtkrc-2.0 ${HOME}/.gtkrc-2.0
ln -sfn ${dir}/.config/gtk-3.0 ${HOME}/.config/gtk-3.0
ln -sfn ${dir}/.fonts ${HOME}/.fonts
fi

echo "################################################################"
echo "Install extra applications"
echo "################################################################"

if ask "Install Chromium?" Y; then
  sudo apt-get install -y chromium-browser
fi

if ask "Install Infinality?" Y; then
  sudo add-apt-repository -y ppa:no1wantdthisname/ppa
  sudo apt-get update
  sudo apt-get install -y fontconfig-infinality --fix-missing
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

echo "################################################################"
echo "Final cleanup"
echo "################################################################"

sudo apt-get autoremove -y