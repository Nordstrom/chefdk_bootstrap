# Revision History for chefdk_bootstrap

## Unreleased
* Bump ChefDK to 0.14.25

## 1.9.0
* Fix [#134](https://github.com/Nordstrom/chefdk_bootstrap/issues/134):
  Put SSH on the path so `kitchen login` works
* Fix [#132](https://github.com/Nordstrom/chefdk_bootstrap/issues/132):
  Add comments to $Profile.CurrentUserAllHosts PowerShell profile
* Fix [#63](https://github.com/Nordstrom/chefdk_bootstrap/issues/63):
  Dry up the cleanup in the Windows bootstrap
* Fix [#133](https://github.com/Nordstrom/chefdk_bootstrap/issues/133):
  Clean up berkshelf environment variable from Windows bootstrap
* Fix [#47](https://github.com/Nordstrom/chefdk_bootstrap/issues/47):
  Add kitchen config.yml file to pass through proxy settings (when needed)

## 1.8.0
* Fix [#130](https://github.com/Nordstrom/chefdk_bootstrap/issues/130):
  Move PowerShell Profile customizations to a PowerShell module on the $env:PSModulePath

* Fix [#75](https://github.com/Nordstrom/chefdk_bootstrap/issues/75):
  Write PowerShell profile customizations to $Profile.CurrentUserAllHosts

### Upgrading from 1.7
This cookbook no longer writes C:\WINDOWS\System32\WindowsPowerShell\v1.0\profile.ps1.
If you are upgrading from 1.7 or earlier you will need to remove [the lines added by the chefdk_bootstrap in v1.7.0](https://github.com/Nordstrom/chefdk_bootstrap/blob/v1.7.0/templates/windows/global_profile.ps1.erb)
or delete the file.

## 1.7.0
* Install ChefDK 0.13.21 via bootstrap script
* Add InSpec integration tests for each (Windows) component
* Recommend PowerShell 5.0 instead of 4.0 in README
* Add ConEmu on Windows (Issue #115)
* Fix PowerShell color contrast issues (Issues #40, #117)

## 1.6.2
* Use [atom cookbook](https://supermarket.chef.io/cookbooks/atom) to install Atom

## 1.6.1
* Fix Atom install on Windows. Fixes [#109](https://github.com/Nordstrom/chefdk_bootstrap/issues/109).

## 1.6.0
* Switch from chocolatey resource in Chocolatey cookbook to chocolatey_package
  resource in Chef 12.7
* Install Virtualbox on Mac via [`dmg_package`](https://github.com/chef-cookbooks/dmg#dmg_package) resource instead of homebrew. Fixes [#97](https://github.com/Nordstrom/chefdk_bootstrap/issues/97).

## 1.5.4
* Use sudo to remove temporary directory
* Switch .kitchen.yml to use @mwrockx's Windows2012R2 Atlas Vagrant box.
* Mac: Fix [#81](https://github.com/Nordstrom/chefdk_bootstrap/issues/81) by hiding script download progress from cURL
* Improve spec coverage from 46% to 87%
* Bootstrap now writes correct Ohai disabled_plugins syntax to remove deprecation warning.

## 1.5.3
* Mac: Don't create directories which homebrew cookbook already creates
* Bootstrap: create temporary directory using `mktemp -d`
* Stop creating ~/.chef, ~/chef, and ~/chef/cookbooks directories in bootstrap script
since creating these directories has been moved to the cookbook.

## 1.5.2
* Bump homebrew dependency to ~> 2.0 because Homebrew cookbook v2.0.4 fixes
[chef-cookbooks/homebrew#87](https://github.com/chef-cookbooks/homebrew/issues/87). This will fix the bootstrap for Mac users.
* Update Windows cookbook dependency

## 1.5.1
* Fix the chefdk_julia install attribute to match others and document it

## 1.5.0
* Install 64-bit git 2.7
* Install [Git Credential Manager for Windows](https://github.com/Microsoft/Git-Credential-Manager-for-Windows),
which replaces the deprecated git-credential-winstore.
* Add option to install chefdk-julia
* Refactor specs. Use shared_context for Windows and Mac Chef runs. Fix broken
tests by setting `node['vagrant']['checksum']` attribute in Chef runs.

## 1.4.1
* Install Vagrant via community Vagrant cookbook

## 1.4.0
* create ~/.chef, ~/chef, ~/chef/cookbooks
* fixes [#43](https://github.com/Nordstrom/chefdk_bootstrap/issues/43)

## 1.3.3
* Mac OS X: create /opt/homebrew-cask directory
* fixes [#60](https://github.com/Nordstrom/chefdk_bootstrap/issues/60)

## 1.3.2
* Windows: Check for Admin rights or exit
* Windows: Use omnitruck ChefDK installation, selecting specific version
* Windows: Check installed ChefDK version, do the right thing.
* Windows: Check for error status after various commands
* fixes [#56](https://github.com/Nordstrom/chefdk_bootstrap/issues/56)
* fixes [#49](https://github.com/Nordstrom/chefdk_bootstrap/issues/49)
* fixes [#33](https://github.com/Nordstrom/chefdk_bootstrap/issues/33)

## 1.3.1
* Switch from brew-cask to omnitruck chefdk installation for Mac OS X
* Make bootstrap incrementally more robust on Mac OS X
* fixes [#33](https://github.com/Nordstrom/chefdk_bootstrap/issues/33)
* Fixes [#45](https://github.com/Nordstrom/chefdk_bootstrap/issues/45)
* fixes [#56](https://github.com/Nordstrom/chefdk_bootstrap/issues/56) on mac osx,
  still an issue on windows

## 1.3.0
* Depend on chocolatey 0.5.0 to improve installation behind a proxy
* Install Git v2.5.1 instead of v1.9.5

### Dev environment changes
* Travis CI builds use ChefDK built-in gems instead of Gemfile + bundler
* Rakefile defines default task of :style, :spec

## 1.2.4
* Minor edits to README for clarity

## 1.2.3
* Make non-proxy README instructions work for Windows. Fixes [#35](https://github.com/Nordstrom/chefdk_bootstrap/issues/35)
* Clear screen as first step in bootstrap script. Fixes [#34](https://github.com/Nordstrom/chefdk_bootstrap/issues/34)

## 1.2.2
* Add Apache 2.0 license header.

## 1.2.1
* Add [Travis CI](https://travis-ci.org/) support to run style and unit tests
* Recommend PowerShell 4.0 instead of PowerShell 3.0 because 4.0 supports DSC.

## 1.2.0
* Update bootstrap script to take a private source and cookbook name and add it to the Berksfile.
* Update README.

## 1.1.3
* Add guards around file deletions.

## 1.1.2
* Edit README to clarify proxy instructions.

## 1.1.1
* Add instructions for no_proxy environment variable in the README.

## 1.1.0
* Set proxy environment variables in powershell_profile.
* This enables command-line tools like git, cURL, and Test Kitchen to work behind a proxy.

## 1.0.3
* Fix bug in Atom setup for Windows

## 1.0.2
* Edited the README to make the markdown for Chef Supermaket consistent.

## 1.0.1
* Clarified Windows bootstrap instructions.

## 1.0.0
* Added Mac bootstrap functionality.

## 0.3.0
* Add ability to set `http_proxy`, `https_proxy`, and `no_proxy` env vars.

These env vars allow Chef related command line tools, e.g. git, berkshelf, to
work via a web proxy.

## 0.2.4
* Add proxy support to `bootstrap` script.

## 0.2.3
* Update README
* Add introduction to bootstrap script.
* Add Atom source URL for Mac platform

## 0.2.2
* Bootstrap script bug fixes

## 0.2.1
* Add PowerShell bootstrap script

## 0.2.0

* [Remove support for PuTTY](https://github.com/Nordstrom/chefdk_bootstrap/issues/6)
  in favor of using git-provided ssh client.

  PuTTY is difficult to configure and outside the scope of what this cookbook is
  trying to do. Furthermore the Github for Windows client doesn't use PuTTY
  either.

## 0.1.1

* Install git via [git cookbook](https://supermarket.chef.io/cookbooks/git)
  instead of [chocolatey](https://chocolatey.org/).

* Install [atom editor](https://atom.io/) via windows_package resource instead
  of chocolatey.

## 0.1.0

* Initial version
