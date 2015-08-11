#!/usr/bin/env bash

cookbook_name=$1
private_supermarket=$2

if [[ ! -z "$private_supermarket" ]]; then
  private_source="source '$private_supermarket'"
fi

if [[ -z "$cookbook_name" ]]; then
 cookbook='chefdk_bootstrap'
else
 cookbook=$cookbook_name
fi

# define bootstrapCookbook
bootstrapCookbook='chefdk_bootstrap'

# make userChefDir variable
userChefDir=~/chef

# introduction
cat <<EOF
This script will:

1. Install the latest ChefDK package via Homebrew
2. Create a 'chef' directory in your user profile (home) directory
3. Download the 'chefdk_bootstrap' cookbook via Berkshelf
4. Run 'chef-client' to install the rest of the tools you will need
EOF

# creating a Chef directory for Chef development
if [[ ! -d "$userChefDir" ]]; then
  mkdir "$userChefDir"
  echo 'I am creating the ~/chef directory'
fi

# create Berksfile so that we can install the correct cookbook dependencies
cat > $userChefDir/Berksfile <<EOF
source 'https://supermarket.chef.io'
$private_source

cookbook '$cookbook'
EOF

# create client.rb file so that Chef client can find its dependant cookbooks
cat > $userChefDir/client.rb <<EOF
cookbook_path File.join(Dir.pwd, 'berks-cookbooks')
EOF

# install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install brew-cask
brew install caskroom/cask/brew-cask

# install chefDK
brew cask install chefdk

# making sure that we are vendor cookbooks into a sub directory of the userChefDir
cd "$userChefDir"
berks vendor

# run chef-client (installed by ChefDK) to bootstrap this machine
sudo -E chef-client -z -l error -c "$userChefDir/client.rb" -o "$bootstrapCookbook"

# cleanup
if [[ -f "$userChefDir/berksfile" ]]; then
  rm "$userChefDir/berksfile"
fi

if [[ -f "$userChefDir/Berksfile.lock" ]]; then
  rm "$userChefDir/Berksfile.lock"
fi

if [[ -f "$userChefDir/client.rb" ]]; then
  rm "$userChefDir/client.rb"
fi

if [[ -d berks-cookbooks ]]; then
  rm -r berks-cookbooks
fi
