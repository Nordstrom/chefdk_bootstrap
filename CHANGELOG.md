# Revision History for chefdk_bootstrap

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
