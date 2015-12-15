# Revision History for chefdk_bootstrap

## 1.4.0
* create ~/.chef, ~/chef, ~/chef/cookbooks
* fixes #43

## 1.3.3
* Mac OS X: create /opt/homebrew-cask directory
* fixes #60

## 1.3.2
* Windows: Check for Admin rights or exit
* Windows: Use omnitruck ChefDK installation, selecting specific version
* Windows: Check installed ChefDK version, do the right thing.
* Windows: Check for error status after various commands
* fixes #56
* fixes #49
* fixes #33

## 1.3.1
* Switch from brew-cask to omnitruck chefdk installation for mac osx
* Make bootstrap incrementally more robust on mac osx
* fixes #33, #45
* fixes #56 on mac osx, still an issue on windows

## 1.3.0
* Depend on chocolatey 0.5.0 to improve installation behind a proxy
* Install Git v2.5.1 instead of v1.9.5

### Dev environment changes
* Travis CI builds use ChefDK built-in gems instead of Gemfile + bundler
* Rakefile defines default task of :style, :spec

## 1.2.4
* Minor edits to README for clarity

## 1.2.3
* Make non-proxy README instructions work for Windows. Fixes #35
* Clear screen as first step in bootstrap script. Fixes #34

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
* This enables command-line tools like git, curl, and Test Kitchen to work behind a proxy.

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
