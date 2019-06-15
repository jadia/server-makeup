#!/bin/bash
: '
Shell customization script.
Author: github.com/th3karkota
Date: 2019-06-15
'

##### Colors #####
blueHigh="\e[44m"
cyan="\e[96m"
clearColor="\e[0m"
redHigh="\e[41m"
green="\e[32m"
greenHigh="\e[42m"

#### check if script is run as root ####
if [[ $EUID -ne 0 ]]; then
    echo -e "$blueHigh This script must be run as root $clearColor"
    exit 1
fi

function redFlags() {
    if [ $? == 0 ]; then
        echo -e "$clearColor $greenHigh Success: $1. $clearColor"
    else
        echo -e "$clearColor $redHight Failed: $1. $clearColor"
    fi
}

#### Functions ####

function poop () {
    # Why poop? That's the first thing you do in the morning,
    # this system just woke-up, what do you want it to do first?
    
    apt-get update && \\
    apt-get install -y \
    vim \
    glances \
    git \
    wget \
    curl \
    unzip \
    tmux \
    zsh
    redFlags "Update"
    # Now it can take bath and brush it's RAM chips.
}

function ohMyzsh () {
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" --unattended
    redFlags "ohMyzsh"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}


function dotFiles () {
    git clone https://github.com/th3karkota/server-makeup.git
    # !!! ATTENTION: Removing previous .tmux and .git folders.
    rm -rf .tmux .git
    ls -A server-makeup/ | xargs -r -I {} mv -f 'server-makeup/{}' .
    redFlags "dot-files Moving"
    ln -s -f .tmux.conf.local .tmux/.tmux.conf.local
    mv -f agnoster.zsh-theme $HOME/.oh-my-zsh/themes/agnoster.zsh-theme
    # cleanup
    rmdir server-makeup
}

function changeShell () {
    chsh -s /usr/bin/zsh $USER && exec zsh
}
#### MAIN ####
poop
ohMyzsh
dotFiles
changeShell
