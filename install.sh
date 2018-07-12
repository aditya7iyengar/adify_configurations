#!/bin/bash

#############
### ABOUT ###
#############
# TODO: Better Description

#############
### USAGE ###
#############
# From the terminal:
# $ bash <(wget -qO- https://raw.githubusercontent.com/aditya7iyengar/adify_configurations/master/install.sh)
# OR
# $ bash <(curl -s https://raw.githubusercontent.com/aditya7iyengar/adify_configurations/master/install.sh)


####################
### SUPPORTED OS ###
####################
# This Script is setup to run only on the following OS (Kernels):
# - Arch Linux (Manjaro, Antergos, Anacrchy)
# - Mac OS
# - Ubuntu
# - PopOS
# - Debian
# - CentOS
# - Fedora

####################
### REQUIREMENTS ###
####################
# - Internet Connection
# - Unzip
# - Wget/Curl
# - Sudo
# - Git
# - One of the Supported OS(s)
# - Admin Privileges of the computer being adified

###############
### PRELUDE ###
###############
# Detects Shell Type
# Detects

################
### VERSIONS ###
################
VERSION="0.2.0"
RUBY_VERSION="2.5.0"
ASDF_VERSION="0.5.0"

YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

_announce_step() {
  echo -e """$BLUE
==========================================================
$1.......
==========================================================$NC"""
}

_announce_error(){
  echo -e """
$RED[\u2717] $1 $NC
  """
  exit 1
}

_announce_success() {
  echo -e """
$GREEN[\u2713] $1 $NC
  """
}

_announce_info() {
  echo -e """$BLUE
---> $1 $NC
  """
}

check_os() {
  _announce_step "Detecting OS"

  kernel="`uname`"

  case $kernel in
    'Linux')
      check_linux
    ;;
    'Darwin')
      OS='mac'
      _announce_success "OS is $OS. Adify Configurations is supported for $OS"
    ;;
    *)
      _announce_error "Adify Configurations isn't supported for kernel, $kernel"
    ;;
  esac
}

check_linux() {
  OS="`cat /etc/os-release | grep ^NAME`"

  case $OS in
    *Arch*)
      OS='arch_linux'
      _announce_success "OS is $OS. Adify Configurations is supported for $OS"
    ;;
    *Antergos*)
      OS='arch_linux'
      _announce_success "OS is $OS. Adify Configurations is supported for $OS"
    ;;
    *Manjaro*)
      OS='arch_linux'
      _announce_success "OS is $OS. Adify Configurations is supported for $OS"
    ;;
    *Ubuntu*)
      OS='ubuntu'
      _announce_success "OS is $OS. Adify Configurations is supported for $OS"
    ;;
    *Debian*)
      OS='debian'
      _announce_success "OS is $OS. Adify Configurations is supported for $OS"
    ;;
    *Pop!_OS*)
      OS='pop_os'
      _announce_success "OS is $OS. Adify Configurations is supported for $OS"
    ;;
    # *Centos*)
    #   OS='centos'
    #   _announce_success "OS is $OS. Adify Configurations is supported for $OS"
    # ;;
    # *Fedora*)
    #   OS='fedora'
    #   _announce_success "OS is $OS. Adify Configurations is supported for $OS"
    # ;;
    *)
      _announce_error "Adify Configurations isn't supported for Linux OS: $OS"
    ;;
  esac
}

# Public: This is a general-purpose function to ask Yes/No questions in Bash, 
# either # with or without a default answer. It keeps repeating the question 
# until it gets a valid answer.
#
# Takes two arguments, the question to be asked and default answer. If no
# default answer is given, it repeats until it gets a valid answer (Y or N).
#
# $1 - Question to be asked.
# $2 - Default answer 
#
# Examples
#
# # Generic Usage
# if ask "Do you want to do such-and-such?"; then
#     echo "Yes"
# else
#    echo "No"
# fi

# # Default to Yes if the user presses enter without giving an answer:
# if ask "Do you want to do such-and-such?" Y; then
#    echo "Yes"
# else
#    echo "No"
# fi
#
# # Default to No if the user presses enter without giving an answer:
# if ask "Do you want to do such-and-such?" N; then
#    echo "Yes"
# else
#    echo "No"
# fi
#
# # Only do something if you say Yes
# if ask "Do you want to do such-and-such?"; then
#    said_yes
# fi
#
# Source:
# https://gist.github.com/davejamesmiller/1965569
ask() {
  local prompt default reply

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

    # Ask the question (not using "read -p" as it uses stderr not stdout)
    echo -n "$1 [$prompt] "

    # Read the answer (use /dev/tty in case stdin is redirected 
    # from somewhere else)
    read reply </dev/tty

    # Default?
    if [ -z "$reply" ]; then
      reply=$default
    fi

    # Check if the reply is valid
    case "$reply" in
      Y*|y*) return 0 ;;
      N*|n*) return 1 ;;
    esac
  done
}

check_asdf() {
  _announce_step "Checking ASDF-VM"

  if [ -d "$HOME/.asdf" ]; then
    _announce_success "ASDF already installed"
    asdf=true
  else
    _announce_success "No ASDF Found"
    asdf=false
  fi
}

install_asdf() {
  _announce_step "Installing ASDF ${ASDF_VERSION}"
  git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf --branch v${ASDF_VERSION}
  echo -e "\n. ${HOME}/.asdf/asdf.sh" >> ${HOME}/.${1}rc
  echo -e "\n. ${HOME}/.asdf/completions/asdf.bash" >> ${HOME}/.${1}rc
  . ${HOME}/.asdf/asdf.sh
  . ${HOME}/.asdf/completions/asdf.bash
  asdf=true
}
