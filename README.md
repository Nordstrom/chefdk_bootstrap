# ChefDK_Bootstrap
## Setup your laptop for Chef development in minutes

Run one simple command to easily setup your Windows machine
for Chef cookbook development in about **20 minutes**.

### The bootstrap script will:
1. Install the latest [ChefDK](https://downloads.chef.io/chef-dk/) package from Chef.
1. Create a `chef` directory in your home directory for your cookbook development.
1. Using `chef-client`, install developer tools required for Chef cookbook development, like git, Vagrant, and the Atom editor.

## Quickstart - Windows

Copy the PowerShell commands below and paste them into a **PowerShell Admin** console. This will execute the [bootstrap](https://raw.githubusercontent.com/Nordstrom/chefdk_bootstrap/master/bootstrap.ps1)
script on your workstation.

```PowerShell
$script = (Invoke-WebRequest -Uri https://raw.githubusercontent.com/Nordstrom/chefdk_bootstrap/master/bootstrap.ps1).Content
$script | Invoke-Expression
```

### If you're behind a proxy, run this instead...
If you need to go through a proxy server use this version:

```PowerShell
$env:http_proxy='http://myproxy.example.com:8080'; $env:https_proxy=$env:http_proxy; (Invoke-WebRequest -Uri https://raw.githubusercontent.com/Nordstrom/chefdk_bootstrap/master/bootstrap.ps1 -ProxyUseDefaultCredentials -Proxy $env:https_proxy).Content | Invoke-Expression
```

## Quickstart - Mac

Mac support is coming soon.

## What does it do?
This cookbook installs these tools:

### Editor
[Atom](https://atom.io), a free, general purpose, cross-platform, open source,
text editor. Out of the box, Atom supports all the languages you will need
for Chef development: Ruby, PowerShell, Bash, XML, JSON, etc.

### Source Control
[Git](http://git-scm.com/) - command line git client and tools.


### Local Virtualization
[Virtualbox](https://www.virtualbox.org/) - Oracle's free, open source virtualization tool for local cookbook testing.

[Vagrant](https://www.vagrantup.com/) - ChefDK's included [Test Kitchen]() tool uses Vagrant to spin up local VMs for cookbook testing.

----

## Recipes

### default
* Installs [Chocolatey](https://chocolatey.org/), a Windows package manager, similar to `apt-get` on Ubuntu or `homebrew` on Mac. Chocolatey is used to install packages like `posh-git` and `kdiff3`.

* Installs all the other tools marked `true` in the
`node['chefdk_bootstrap']['package']` hash.

* Includes the Powershell profile configuration recipe.

### atom
* Installs the Atom editor

### git
* Installs git, git-credential-winstore, and posh-git.

### gitextensions
* Installs gitextensions, a GUI git client.

### kdiff3
* Installs the free, open-source diff/merge tool, kdiff3.

### powershell_profile
* Configures a global PowerShell profile to correct the $env:HOME environment
variable and run `chef shell-init powershell`.

### vagrant
* Installs Vagrant.

### virtualbox
* Installs Virtualbox.

## Attributes

The attributes defined by this recipe are organized under the
`node['chefdk_bootstrap']` namespace.

Attribute | Description | Type   | Default
----------|-------------|--------|--------
['atom']['source_url'] | Windows: Atom installer package source URL | URL String | https://atom.io/download/windows
['atom']['source_url'] | Mac: Atom installer package source URL | URL String | https://atom.io/download/mac
['package']['atom'] | Whether to install Atom or not | boolean | true
['package']['kdiff3'] | Whether to install kdiff3 or not | boolean | true
['package']['vagrant'] | Whether to install Vagrant or not | boolean | true
['package']['virtualbox'] | Whether to install Virtualbox or not | boolean | true
['package']['git'] | Whether to install git and related packages or not | boolean | true
['package']['gitextensions'] | Whether to install gitextensions or not | boolean | true

----

## Development

The first time you check out this cookbook, run

    bundle

to download and install the development tools.

## Testing

Three forms of cookbook testing are available:

### Style Checks

    bundle exec rake style

Will run foodcritic (cookbook style) and rubocop (Ruby style/syntax)
checks.

### Unit Tests

    bundle exec rake spec

Will run ChefSpec tests.  It is a good idea to ensure that these
tests pass before committing changes to git.

#### Unit Test Coverage

    bundle exec rake coverage

Will run the ChefSpec tests and report on test coverage.  It is a
good idea to make sure that every Chef resource you declare is covered
by a unit test.

#### Automated Testing with Guard

    bundle exec guard

Will run foodcritic, rubocop (if enabled) and ChefSpec tests
automatically when the associated files change.  If a ChefSpec test
fails, it will drop you into a pry session in the context of the
failure to explore the state of the run.

To disable the pry-rescue behavior, define the environment variable
DISABLE_PRY_RESCUE before running guard:

    DISABLE_PRY_RESCUE=1 bin/guard

### Integration Tests

    bundle exec rake kitchen:all

Will run the test kitchen integration tests.  These tests use Vagrant
and Virtualbox, which must be installed for the tests to execute.

After converging in a virtual machine, ServerSpec tests are executed.
This skeleton comes with a very basic ServerSpec test; refer to
http://serverspec.org for detail on how to create tests.

## Author

Nordstrom, Inc.

## License

Copyright 2015 Nordstrom, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
