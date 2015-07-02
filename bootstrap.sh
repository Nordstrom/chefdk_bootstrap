#!/usr/bin/env bash

# define berksfile
read -d '' berksfile << EOF
source 'https://supermarket.chef.io'

cookbook 'chefdk_bootstrap'
EOF

# define chefConfig
read -d '' chefConfig << EOF
cookbook_path File.join(Dir.pwd, 'berks-cookbooks')
EOF

# introduction
read -d '' intro << EOF
This script will:

1. Install the latest ChefDK package via Homebrew
2. Create a 'chef' directory in your user profile (home) directory
3. Download the 'chefdk_bootstrap' cookbook via Berkshelf
4. Run 'chef-client' to install the rest of the tools you will need
EOF

# make userChefDir variable
userChefDir=~/chef

# define bootstrapCookbook
bootstrapCookbook = 'chefdk_bootstrap'

echo "$intro"

# create the chef directory
if [[ ! -d "$userChefDir" ]]; then
  mkdir "$userChefDir"
  echo 'I am creating the ~/chef directory'
fi

cd "$userChefDir"

echo "$berksfile" > $userChefDir/Berksfile

echo "$chefConfig" > $userChefDir/bootstrap.rb

# install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install brew-cask
brew install caskroom/cask/brew-cask

# install chefDK
brew cask install chefdk

berks vendor

# run chef-client (installed by ChefDK) to bootstrap this machine
sudo chef-client -z -l error -c "$userChefDir/bootstrap.rb" -o "$bootstrapCookbook"

#cleanup
rm "$userChefDir/berksfile"
rm "$userChefDir/Berksfile.lock"
rm "$userChefDir/bootstrap.rb"
rm -r berks-cookbooks
