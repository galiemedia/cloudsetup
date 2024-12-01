#!/bin/bash
#
# ---------------------------------------------------------------------------
# A Simple Script to Configure a Debian or Ubuntu-based Cloud Server Instance
# ---------------------------------------------------------------------------
#

debian-greeting () {
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

ubuntu-greeting () {
    sudo echo " "
    echo "+------------------------------------------------------------------------------+"
    echo "| This script is for a fresh Ubuntu 24 install on a Cloud VM.  It sets up base |"
    echo "| packages and essential applications to build and deploy the platform of your |"
    echo "| choice.  If you don't want to proceed, press Ctrl-C now to exit the script.  |"
    echo "+------------------------------------------------------------------------------+"
    echo " "
    read -p "If you are ready to continue, press [Enter] to start the script..."
    echo " "
}

debian-installbase () {
    echo " "
    echo "Setting up some basics before we begin..."
    echo " "
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y apt-transport-https ca-certificates needrestart software-properties-common
    sudo apt install -y curl debian-goodies duf nala nano wget
    wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.24.0/fastfetch-linux-amd64.deb
    sudo dpkg -i ./fastfetch-linux-amd64.deb
    rm -f ./fastfetch-linux-amd64.deb
    sudo nala purge -y ntp
    sudo nala install -y systemd-timesyncd
    sudo systemctl start systemd-timesyncd
}

ubuntu-installbase () {
    echo " "
    echo "Setting up some basics before we begin..."
    echo " "
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y apt-transport-https ca-certificates needrestart software-properties-common
    sudo apt install -y curl debian-goodies duf nala nano wget
    sudo add-apt-repository ppa:utappia/stable
    sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
    sudo apt update
    sudo nala install -y fastfetch ucaresystem-core
}

ufw-setup () {
    sudo nala install -y ufw
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw enable
}

installpkgs () {
    sudo nala update && sudo nala upgrade
    sudo nala install -y build-essential git locate neovim p7zip p7zip-full unzip
    sudo nala install -y bwm-ng glances gpg htop hwinfo iftop iotop net-tools sysstat vnstat
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

distrocheck () {
    clear
    echo " "
    echo "Checking your distribution and version..."
    echo " "
    if [ ! -f /etc/os-release ]; then
        echo " "
        echo "This script was unable to determine your OS. /etc/os-release file not found."
        echo " "
        echo "Helper script will be stopped."
        echo " "
        exit 1
    fi
    . /etc/os-release
    if [ "$ID" = "debian" ]; then
        if [ $(echo "$VERSION_ID >= 12" | bc) != 1 ]; then
            echo " "
            echo "This script is not compatible with your version of Debian."
            echo " "
            echo "Your computer is is currently running: $ID $VERSION_ID"
            echo " "
            echo "This script is for Debian 12 - Setup helper stopped."
            exit 1
        fi
        debian-greeting
        debian-installbase
    elif [ "$ID" = "ubuntu" ]; then
        if [ $(echo "$VERSION_ID >= 24.04" | bc) != 1 ]; then
            echo " "
            echo "This script is not compatible with your version of Ubuntu."
            echo " "
            echo "Your computer is is currently running: $ID $VERSION_ID"
            echo " "
            echo "This script is for Ubuntu 24 - Setup helper stopped."
            exit 1
        fi
        ubuntu-greeting
        ubuntu-installbase
    else 
        echo " "
        echo "This script is not compatible with your distribution."
        echo " "
        echo "Your computer is is currently running: $ID $VERSION_ID"
        echo " "
        echo "This script is for Debian 12 or Ubuntu 24 - Setup helper stopped."
        exit 1
    fi
}

set -eu
distrocheck
installpkgs
installtailscale
needrestart
exit 0
