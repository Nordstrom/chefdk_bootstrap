# Zero to First Cookbook in Twenty Minutes

Run one simple command to easily setup your Windows workstation
for Chef cookbook development in **20 minutes**.

## Quickstart - Windows

Run the command below from a PowerShell Admin console. This will execute the [bootstrap] (https://raw.githubusercontent.com/Nordstrom/chefdk_bootstrap/master/Rakefile) script on your workstation.

```PowerShell
PS> Invoke-WebRequest https://raw.githubusercontent.com/Nordstrom/chefdk_bootstrap/master/bootstrap.ps1 | iex
```

### The bootstrap script will:
1. Install the latest ChefDK package
1. Create a `chef` directory in your home directory.
1. Download the `chefdk_bootstrap` cookbook via [Berkshelf](http://berkshelf.com/)
1. Run `chef-client` to install the rest of the tools you'll need.

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

## Recipes

### default

The default recipe ...

## Attributes

The attributes defined by this recipe are organized under the
`node['chefdk_bootstrap']` namespace.

Attribute | Description | Type   | Default
----------|-------------|--------|--------
...       | ...         | String | ...

## LWRP

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

    bunlde exec rake kitchen:all

Will run the test kitchen integration tests.  These tests use Vagrant
and Virtualbox, which must be installed for the tests to execute.

These are only available for cookbooks that target Unix-like systems.
Support for Windows targets is expected by the end of 2014.

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
