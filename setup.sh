#!/bin/bash
#
# dotfiles Init Script
#
# Author: eric@alluvium.com
#
# Description:  This script installs and initializes Chezmoi on a new host
#

#
# Configuration
#
PACKAGE_LIST="chezmoi age"
CHEZMOI_DIR="$HOME/.config/chezmoi"
CHEZMOI_SSH_KEY="$HOME/.ssh/id_rsa_chezmoi"

#
# Functions
#
function welcome_banner () {
	cat <<EOL
-------------------------------------------------
            _       _    __ _ _
         __| | ___ | |_ / _(_) | ___  ___
        / _\` |/ _ \| __| |_| | |/ _ \/ __|
       | (_| | (_) | |_|  _| | |  __/\__ \\
        \__,_|\___/ \__|_| |_|_|\___||___/
     
-------------------------------------------------
                Deployment Script
-------------------------------------------------
Chezmoi Config Directory : $CHEZMOI_DIR
Chezmoi SSH Key          : $CHEZMOI_SSH_KEY
OS Package List          : $PACKAGE_LIST
-------------------------------------------------

EOL
}

function pre_flight_check () {
	echo "--- Performing Pre-Flight Check"
	if [ ! -f "$CHEZMOI_SSH_KEY" ]; then
		echo "*** ERROR: Specified SSH key $CHEZMOI_SSH_KEY does not exist."
		exit 1
	fi

	if [ -d "$CHEZMOI_DIR" ]; then
		echo "*** WARNING: $CHEZMOI_DIR exists. This script will overwrite existing settings."
		read -p "--- Continue? [yN]: " -n 1 -r
		if [[ ! $REPLY =~ ^[Yy]$ ]]
		then
			echo
			echo "*** Aborting"
			exit 1
		fi
	fi
}

function install_package () {
	package=$1
	if [ -x "$(command -v apk)" ];       then sudo apk add --no-cache $1
	elif [ -x "$(command -v yay)" ]; then yay -S $1
	elif [ -x "$(command -v pacman)" ]; then pacman -S $1
	elif [ -x "$(command -v apt-get)" ]; then sudo apt-get install $1
	elif [ -x "$(command -v dnf)" ];     then sudo dnf install $1
	elif [ -x "$(command -v zypper)" ];  then sudo zypper install $1
	elif [ -x "$(command -v brew)" ];  then brew install $1
	else echo "*** FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $1">&2; fi
}

function install_deps () {
	echo "--- OS Package Dependency Installation (sudo may be required)"
	for p in $PACKAGE_LIST; do
		if [ -x "$(command -v $p)" ]; then
			echo "- $p already installed"
		else
			echo "- Installing $p"
			install_package $p
		fi
	done
}

function chezmoi_init_and_apply () {
	echo "--- Chezmoi Init and Applying Configuration"
	chezmoi init --apply git@github.com:ericreeves/dotfiles.git
}

########################################################################
#
# Main
#
welcome_banner
pre_flight_check
install_deps
chezmoi_init_and_apply

