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
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh) --unattended"
    redFlags "ohMyzsh"
}


function dotFiles () {
    mkdir ~/.tmux
    curl -o $HOME/.tmux/.tmux.conf https://raw.githubusercontent.com/th3karkota/server-makeup/master/.tmux/.tmux.conf
    curl -o $HOME/.tmux.conf.local https://raw.githubusercontent.com/th3karkota/server-makeup/master/.tmux.conf.local
    ln -s -f .tmux.conf.local .tmux/.tmux.conf.local
    curl -o $HOME/.zshrc https://raw.githubusercontent.com/th3karkota/server-makeup/master/.zshrc
    curl https://raw.githubusercontent.com/th3karkota/server-makeup/master/agnoster.zsh-theme > $HOME/.oh-my-zsh/themes/agnoster.zsh-theme
    curl -o $HOME/.aliases https://raw.githubusercontent.com/th3karkota/server-makeup/master/.aliases
}

function changeShell () {
    chsh -s /usr/bin/zsh $USER && exec zsh
}

# copied this function from mbtamuli
function addSSH () {
users=(th3karkota)

for user in "${users[@]}"; do
  curl -fsSL https://github.com/$user.keys | tee -a /root/.ssh/authorized_keys
done
}

#### MAIN ####
poop
ohMyzsh
dotFiles
changeShell
addSSH
