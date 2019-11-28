#!/usr/bin/env bash
#title          :install.sh
#description    :This script will install and configure kegeschs mac.
#author         :kegesch
#date           :2019-11-28
#version        :0.1
#usage          :bash <(curl -s https://raw.githubusercontent.com/kegesch/fresh/master/install.sh)
#bash_version   :3.2.57(1)-release
#===================================================================================

TEMP_DIR=$(mktemp -d)
FISHERMAN_URL="https://git.io/fisher"
PLUGINS_INSTALLER_URL="https://raw.githubusercontent.com/ghaiklor/iterm-fish-fisher-osx/master/install_plugins.sh"
HOMEBREW_INSTALLER_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
RESET_COLOR="\033[0m"
RED_COLOR="\033[0;31m"
GREEN_COLOR="\033[0;32m"
BLUE_COLOR="\033[0;34m"

function reset_color() {
    echo -e "${RESET_COLOR}\c"
}

function red_color() {
    echo -e "${RED_COLOR}\c"
}

function green_color() {
    echo -e "${GREEN_COLOR}\c"
}

function blue_color() {
    echo -e "${BLUE_COLOR}\c"
}

function separator() {
    green_color
    echo "#=============================STEP FINISHED=============================#"
    reset_color
}

function hello() {
    green_color
    echo "                                              "
    echo "       _____                      .__         "
    echo "     _/ ____\______   ____   _____|  |__      " 
    echo "     \   __\\_  __ \_/ __ \ /  ___/  |  \     "  
    echo "      |  |   |  | \/\  ___/ \___ \|   Y  \    "
    echo "      |__|   |__|    \___  >____  >___|  /    "
    echo "                         \/     \/     \/     "
    echo "                                              "
    echo "                 by @kegesch                  "
    echo "                                              "
    echo "                                              "

    blue_color
    echo "It will not install anything, without your direct agreement (do not afraid)"

    green_color
    read -p "Do you want to proceed with installation? (y/N) " -n 1 answer
    echo
    if [ ${answer} != "y" ]; then
        exit 1
    fi

    reset_color
}

function install_command_line_tools() {
    blue_color
    echo "Trying to detect installed Command Line Tools..."

    if ! [ $(xcode-select -p) ]; then
        blue_color
        echo "You don't have Command Line Tools installed"
        echo "They are required to proceed with installation"

        green_color
        read -p "Do you agree to install Command Line Tools? (y/N) " -n 1 answer
        echo
        if [ ${answer} != "y" ]; then
            exit 1
        fi

        blue_color
        echo "Installing Command Line Tools..."
        echo "Please, wait until Command Line Tools will be installed, before continue"
        echo "I can't wait for its installation from the script, so continue..."

        xcode-select --install
    else
        blue_color
        echo "Seems like you have installed Command Line Tools, so skipping..."
    fi

    reset_color
    separator
    sleep 1
}

function install_homebrew() {
    blue_color
    echo "Trying to detect installed Homebrew..."

    if ! [ $(which brew) ]; then
        blue_color
        echo "Seems like you don't have Homebrew installed"
        echo "We need it for completing the installation of your awesome terminal environment"

        green_color
        read -p "Do you agree to proceed with Homebrew installation? (y/N) " -n 1 answer
        echo
        if [ ${answer} != "y" ]; then
            exit 1
        fi

        blue_color
        echo "Installing Homebrew..."

        ruby -e "$(curl -fsSL ${HOMEBREW_INSTALLER_URL})"
        brew update
        brew upgrade

        green_color
        echo "Homebrew installed!"
    else
        blue_color
        echo "You already have Homebrew installed, so skipping..."
    fi

    reset_color
    separator
    sleep 1
}


function install_brew() {
    blue_color
    local app_name=$1
    local brew_name=$2

    echo "Trying to find installed ${brew_name}..."

    if ! [ $(which ${app_name}) ]; then
        blue_color
        echo "I can't find installed ${brew_name}"

        green_color
        read -p "Do you agree to install it? (y/N) " -n 1 answer
        echo
        if [ ${answer} != "y" ]; then
            exit 1
        fi

        blue_color
        echo "Installing ${brew_name}..."

        brew install ${brew_name}

        green_color
        echo "${brew_name} installed!"
    else
        blue_color
        echo "Found installed ${app_name}, so skipping..."
    fi

    reset_color
    separator
    sleep 1
}

function install_cask() {
    blue_color
    local app_name=$1
    local cask_name=$2

    echo "Trying to find installed ${cask_name}..."

    if ! [ $(ls /Applications/ | grep "${app_name}.app") ]; then
        blue_color
        echo "I can't find installed ${cask_name}"

        green_color
        read -p "Do you agree to install it? (y/N) " -n 1 answer
        echo
        if [ ${answer} != "y" ]; then
            exit 1
        fi

        blue_color
        echo "Installing ${cask_name}..."

        brew cask install ${cask_name}

        green_color
        echo "${cask_name} installed!"
    else
        blue_color
        echo "Found installed ${app_name}.app, so skipping..."
    fi

    reset_color
    separator
    sleep 1
}

function install_iterm() {
    install_cask "iTerm" "iterm2"
}

function install_intellij() {
    install_cask "IntelliJ IDEA" "intellij-idea"
}

function install_clion() {
    install_cask "CLion" "clion"
}

function install_code() {
    install_cask "Visual Studio Code" "visual-studio-code"
}

function install_git() {
    install_brew "git" "git"
}

function install_fish() {
    install_brew "fish" "fish"
    blue_color
    echo "Just to be sure, that fish is your default shell i will call chsh."

    echo "$(command -v fish)" | sudo tee -a /etc/shells
    chsh -s "$(command -v fish)"
    
    green_color
    echo "Fish installed!"
    reset_color
    separator
    sleep 1
  }

function install_fonts() {
    green_color
    read -p "Do you want to install powerline fonts? (y/N) " -n 1 answer
    echo
    if [[ ${answer} == "y" || ${answer} == "Y" ]]; then
      blue_color
      echo "Cloning Powerline Fonts into ${TEMP_DIR}..."

      cd ${TEMP_DIR}
      # clone
      git clone https://github.com/powerline/fonts.git --depth=1
      # install
      cd fonts
      ./install.sh
      # clean-up a bit
      cd ..
      rm -rf fonts
      
      green_color
      echo "Powerline Fonts is successfully installed!"
    else 
      blue_color
      echo "Skipping Powerline Fonts installation..."
    fi

    reset_color
    separator
    sleep 1
}

function install_starship() {
    install_brew "starship" "starship"
    echo "starship init fish | source" >> ~/.config/fish/config.fish
}

function install_notion() {
    install_cask "notion" "notion"
}

function install_brave() {
    install_cask "brave" "brave-browser"
}

function install_spotify() {
    install_cask "spotify" "spotify"
}

function install_nextcloud() {
    install_cask "nextcloud" "nextlcoud"
}

function install_rust() {
    install_brew "rustup" "rust"
}

function install_fisherman() {
    blue_color
    echo "Trying to detect installed Fisherman..."
    local fisher=~/.config/fish/functions/fisher.fish

    if ! [ -f "$fisher" ]; then
        blue_color
        echo "Seems like you don't have Fisherman installed"
        echo "Fisher is required for the installation"

        green_color
        read -p "Do you agree to install it? (y/N) " -n 1 answer
        echo
        if [ ${answer} != "y" ]; then
            exit 1
        fi

        blue_color
        echo "Installing Fisher..."

        curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs ${FISHERMAN_URL}

        green_color
        echo "Fisher installed!"
    else 
      blue_color
      echo "You already have Fisherman installed, so skipping..."
    fi

    reset_color
    separator
    sleep 1
}

function install_fisherman_plugins_and_themes() {
    blue_color
    echo "Some of the Fisher plugins requires external dependencies to be installed via Homebrew..."

    green_color
    read -p "Do you want to install Themes and Plugins for Fisher? (y/N) " -n 1 answer
    echo
    if [[ ${answer} == "y" || ${answer} == "Y" ]]; then
        blue_color
        echo "Installing Themes and Plugins..."

        cd ${TEMP_DIR}
        curl -fsSL ${PLUGINS_INSTALLER_URL} > ./plugins_installer
        chmod +x ./plugins_installer
        ./plugins_installer

        green_color
        echo "Themes and Plugins installed!"
    else
        blue_color
        echo "Skipping Themes and Plugins installation..."
    fi

    reset_color
    separator
    sleep 1
}

function post_install() {
    green_color
    echo
    echo
    echo "Setup was successfully done"
    echo "Do not forgot to make two simple, but manual things:"
    echo
    echo "1) Open iTerm -> Preferences -> Profiles -> Colors -> Presets and apply material-design color preset"
    echo "2) Open iTerm -> Preferences -> Profiles -> Text -> Font and apply Meslo font (for non-ASCII as well)"
    echo
    echo "Happy Coding!"

    reset_color
    exit 0
}

function on_sigterm() {
    red_color
    echo
    echo -e "Wow... Something serious happened!"
    echo -e "Though, I don't know what really happened :("

    reset_color
    exit 1
}

hello
install_command_line_tools
install_homebrew
install_iterm
install_fonts
install_fish
install_fisherman
install_fisherman_plugins_and_themes
install_starship
install_rust
install_code
install_brave
install_clion
install_intellij
install_spotify
install_notion
post_install

