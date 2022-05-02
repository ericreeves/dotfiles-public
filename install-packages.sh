#!/bin/bash

#########################################
# Configuration
#########################################
COMMON_PACKAGES="fpp fasd fff fd ripgrep ctop fx tmux-xpanes fzf tmux diff-so-fancy rpl htop btop kubectl kops eksctl kubectx k9s aws-vault jq"
BREW_PACKAGES=""
ARCH_PACKAGES="keychain teams 1password 1password-cli xclip xcape alacritty visual-studio-code-bin vim aws-cli"
FLATHUB_PACKAGES="com.getferdi.Ferdi"
#########################################

function install_arch_packages () {
    if [ -x "$(command -v yay)" ]; then
        yay --save --answerclean All --answerdiff All
        yay --save --nocleanmenu --nodiffmenu
        echo "--- Prompting for Sudo password"
        sudo echo
        for p in $COMMON_PACKAGES $ARCH_PACKAGES; do
            if ! yay -Q $p >/dev/null 2>&1; then
                echo "--- Installing $p"
                echo y | yay --needed -S $p
                # yay_install $p
            else
                echo "--- Skipping $p"
            fi
        done
    fi
}

function install_aws_cli_bin () {
    if ! aws >/dev/null 2>&1; then
        echo "--- Installing aws-cli"
        pushd /tmp >/dev/null
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install --update
        rm -f awscliv2.zip
        popd >/dev/null
    fi
}

function install_brew_packages () {
    if [ -x "$(command -v brew)" ]; then
        for p in $COMMON_PACKAGES $BREW_PACKAGES; do
            echo "--- Installing $p"
            brew install $p
        done
        install_aws_cli_bin
    fi
}

function install_flatpak_packages () {
    RELEASE=$(lsb_release -i | cut -d: -f2 | sed 's|\s||g')
    if [ "${RELEASE}" == "Fedora" ]; then
        for p in $FLATHUB_PACKAGES; do
            echo "--- Installing $p"
            flatpak install flathub $p
        done
    fi
}

install_brew_packages
install_flatpak_packages
install_arch_packages
