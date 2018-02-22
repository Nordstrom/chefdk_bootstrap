# chefdk_bootstrap_nord

This is a Nordstrom-specific wrapper around chefdk_bootstrap and is included as a sample for writing your own installation wrapper.
See https://github.com/Nordstrom/chefdk_bootstrap. A specific version of chefdk is picked for the
installation.  The restaurant and jetbridge pipelines will use the same version of rubocop and foodcritic as installed with the version of chefdk specified in here.
In addition to package installation a ~/.gitconfig file is created with useful defaults.

## Windows installation

To install, open a PowerShell window (with Run As Administrator) and paste this in:

```PowerShell
(Invoke-WebRequest -Uri https://git.nordstrom.net/projects/CHF/repos/chefdk_bootstrap_nord/browse/bootstrap.ps1?raw).Content | Invoke-Expression
```

## Mac installation

To install, open a terminal and paste this in:

```bash
curl https://git.nordstrom.net/projects/CHF/repos/chefdk_bootstrap_nord/browse/bootstrap.sh?raw | bash
```

## Alternate installation

If you have any issues with the script above, you can install/configure the components individually:

### Essential Configuration and Tools

#### 1) Set up your proxy variables

Windows: add this to your $PROFILE.CurrentUserAllHosts (~/Documents/WindowsPowerShell/profile.ps1)

```PowerShell
$env:http_proxy='http://webproxysea.nordstrom.net:8181'
$env:https_proxy=$env:http_proxy
$env:no_proxy='localhost,127.0.0.1,nordstrom.net'
```

Mac: add the same environment variables to your profile, e.g. ~/.bash_profile

```bash
export http_proxy=http://webproxysea.nordstrom.net:8181
export https_proxy=$http_proxy
export no_proxy='localhost,127.0.0.1,nordstrom.net'
```

#### 2) Install these

* [ChefDK](https://downloads.chef.io/chefdk)
* [Atom](https://atom.io/)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [git](https://git-scm.com/download)

#### 3) And then run these configurations:

Windows:

* `chef gem install chefdk-julia` to install our specialized cookbook generator
* `mkdir ~/.kitchen` to make a Test Kitchen config folder
* `iwr -proxy $env:https_proxy https://raw.githubusercontent.com/Nordstrom/chefdk_bootstrap/master/files/default/kitchen.config.yml -outfile ~/.kitchen/config.yml` to configure Test Kitchen
* `git clone https://$env:USERNAME@git.nordstrom.net/scm/chf/dotchef.git $env:USERPROFILE\.chef` to configure chef

Mac:

* `chef gem install chefdk-julia` to install our specialized cookbook generator
* `mkdir ~/.kitchen` to make a Test Kitchen config folder
* `curl --proxy $https_proxy https://raw.githubusercontent.com/Nordstrom/chefdk_bootstrap/master/files/default/kitchen.config.yml --output ~/.kitchen/config.yml` to configure Test Kitchen
* `git clone https://$USER@git.nordstrom.net/scm/chf/dotchef.git ~/.chef` to configure chef

### Bonus

You can also install these helpful tools if you want to:

#### Windows tools

* [Chocolatey](https://chocolatey.org/install) package manager to help install other programs
* [poshgit](https://github.com/dahlbyk/posh-git) - install with `choco install poshgit` to customize your PowerShell prompt
* [conemu](https://conemu.github.io/) - install with `choco install conemu` to get a better console

#### Mac tools

* [homebrew](https://brew.sh/) package manager to help install other programs
* [iterm2](https://www.iterm2.com/)
