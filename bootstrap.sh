#!/usr/bin/env bash

# install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install brew-cask
brew install caskroom/cask/brew-cask

# install chefDK
brew cask install chefdk
