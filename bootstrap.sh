#!/bin/bash
: '
VPS bootstrap script
Author: github.com/jadia
Mail: nitish[at]jadia.dev
Date: 2019-06-15
Version: v0.2
'

##### Colors #####
blueHigh="\e[44m"
cyan="\e[96m"
clearColor="\e[0m"
redHigh="\e[41m"
green="\e[32m"
greenHigh="\e[42m"

#### check if script is run as root ####
# if [[ $EUID -ne 0 ]]; then
#     echo -e "$blueHigh This script must be run as root $clearColor"
#     exit 1
# fi

function redFlags() {
    if [ $? == 0 ]; then
        echo -e "$clearColor $greenHigh Success: $1. $clearColor"
    else
        echo -e "$clearColor $redHight Failed: $1. $clearColor"
    fi
}

#### Functions ####

function install_packages () {
    
    sudo apt update && \
    sudo apt install -y \
    vim \
    git \
    wget \
    curl \
    unzip \
    tmux \
    python3 \
    python3-pip \
    zsh
    redFlags "Update"
}

function ohMyzsh () {
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh) --unattended"
    redFlags "ohMyzsh"
}


function dotFiles () {
    mkdir $HOME/.tmux
    curl -o $HOME/.tmux/.tmux.conf https://raw.githubusercontent.com/jadia/server-makeup/master/.tmux/.tmux.conf
    ln -s -f $HOME/.tmux/.tmux.conf
    curl -o $HOME/.tmux/.tmux.conf.local https://raw.githubusercontent.com/jadia/server-makeup/master/.tmux.conf.local
    ln -s -f $HOME/.tmux/.tmux.conf.local $HOME/.tmux.conf.local
    curl -o $HOME/.zshrc https://raw.githubusercontent.com/jadia/server-makeup/master/.zshrc
    curl https://raw.githubusercontent.com/jadia/server-makeup/master/agnoster.zsh-theme > $HOME/.oh-my-zsh/themes/agnoster.zsh-theme
    touch $HOME/.aliases
    curl -o $HOME/.aliases https://raw.githubusercontent.com/jadia/server-makeup/master/.aliases
}

function changeShell_banner () {
    echo -e """$clearColor$blueHigh
   Please run the following command to make zsh your default shell:


                            sudo chsh -s /usr/bin/zsh \$USER

    $clearColor
    """
}



function addSSH () {
users=(jadia)
mkdir -p $HOME/.ssh
touch $HOME/.ssh/authorized_keys
for user in "${users[@]}"; do
  curl -fsSL https://github.com/$user.keys | tee -a $HOME/.ssh/authorized_keys
done
} # Source: @mbtamuli


#### MAIN ####
install_packages
ohMyzsh
dotFiles
addSSH
# Shell must always be changed at the end
changeShell_banner
