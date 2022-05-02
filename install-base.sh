#!/bin/bash

function install_homebrew_curl () {
    echo "  - Installing Homebrew via CurlBash" 
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

function install_ubuntu_packages () {
    echo "  - Installing Ubuntu System Packages"
    sudo apt update
    sudo apt install build-essential procps curl file git
    install_homebrew_curl
}

function install_fedora_packages () {
    echo "  - Installing Fedora System Packages"
    sudo yum groupinstall 'Development Tools'
    sudo yum install procps-ng curl file git
    sudo yum install libxcrypt-compat # needed by Fedora 30 and up
    install_homebrew_curl
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

function install_arch_packages () {
    echo "  - Installing Nothing.  This is Arch.  Use yay/pacman, Loser."
    exit 0
}

function check_homebrew () {
    if [ -x "$(command -v brew)" ]; then 
        echo "--- Homebrew Already Installed"
        exit 0
    fi
}

function install_brew_package () {
    if [ ! -x "$(command -v $1)" ]; then 
        echo "--- Installing $1"
        test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        brew install $1
    fi
}

function install_all () {
	echo "  - OS Package Dependency Installation (sudo password may be required)"
    RELEASE=$(lsb_release -i | cut -d: -f2 | sed 's|\s||g')
    if [ "${RELEASE}" == "Pop" ]; then 
        check_brew
        install_ubuntu_packages
        install_homebrew
        install_brew_package wget
    elif [ "${RELEASE}" == "Ubuntu" ]; then 
        check_brew
        install_ubuntu_packages
        install_homebrew
        install_brew_package wget
    elif [ "${RELEASE}" == "Mint" ]; then 
        check_brew
        install_ubuntu_packages
        install_homebrew
        install_brew_package wget
    elif [ "${RELEASE}" == "ManjaroLinux" ]; then 
        install_arch_packages
    elif [ "${RELEASE}" == "EndeavourOS" ]; then 
        install_arch_packages
    elif [ "${RELEASE}" == "Arch" ]; then 
        install_arch_packages
    elif [ "${RELEASE}" == "Fedora" ]; then 
        check_brew
        install_fedora_packages
        install_homebrew
        install_brew_package wget

    else 
        echo "*** Unknown OS.  Aborting..."
    fi
}


########################################################################
#
# Main
#
install_all
