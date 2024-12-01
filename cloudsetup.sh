#!/bin/bash
#
# --------------------------------------------
# A Simple Script to Configure a Debian Server
# --------------------------------------------
#

greeting () {
    sudo echo " "
    echo "+------------------------------------------------------------------------------+"
    echo "| This script is for a fresh Debian 12 install on a Cloud VM.  It sets up base |"
    echo "| packages and essential applications to build and deploy the platform of your |"
    echo "| choice.  If you don't want to proceed, press Ctrl-C now to exit the script.  |"
    echo "+------------------------------------------------------------------------------+"
    echo " "
    read -p "If you are ready to continue, press [Enter] to start the script..."
    echo " "
}

installbase () {
    echo " "
    echo "Setting up some basics before we begin..."
    echo " "
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y apt-transport-https ca-certificates needrestart software-properties-common
    sudo apt install -y curl debian-goodies duf nala nano wget
    wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.24.0/fastfetch-linux-amd64.deb
    sudo dpkg -i ./fastfetch-linux-amd64.deb
    rm -f ./fastfetch-linux-amd64.deb
}

installpkgs () {
    sudo nala update && sudo nala upgrade
    sudo nala install -y build-essential git locate neovim p7zip p7zip-full unzip
    sudo nala install -y bwm-ng glances gpg htop hwinfo iftop iotop net-tools sysstat vnstat
    sudo nala purge -y ntp
    sudo nala install -y systemd-timesyncd
    sudo systemctl start systemd-timesyncd
    sudo apt update
    sudo apt install --fix-missing -y
    sudo apt upgrade --allow-downgrades -y
    sudo apt full-upgrade --allow-downgrades -y
    sudo apt install -f
    sudo apt autoremove -y
    sudo apt autoclean
    sudo apt clean
}

installtailscale () {
    echo " "
    echo "The script will now install Tailscale."
    echo " "
    read -p "If you are ready to continue, press [Enter] to install Tailscale..."
    echo " "
    curl -fsSL https://tailscale.com/install.sh | sh
    echo " "
    sudo tailscale up
    echo " "
    echo "Tailscale has now been installed and is online."
    echo " "
}

needrestart () {
    echo " "
    sudo /sbin/needrestart
    echo " "
    echo "+------------------------------------------------------------------------------+"
    echo "|               The server configuration script is now complete.               |"
    echo "+------------------------------------------------------------------------------+"
    echo " "
}

set -eu
greeting
installbase
installpkgs
installtailscale
needrestart
exit 0
