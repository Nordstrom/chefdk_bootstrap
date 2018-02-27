# Contributing

Thank you so much for taking the time to contribute! Below is some information that you need to contribute effectively.

## General Observations

The repository contains a cookbook and installation scripts.  The installation scripts
are not part of the cookbook. They are used to install chefdk and then to 
download the chefdk_bootstrap cookkbook and run it.

This repository supports both mac-os and windows servers. Development is simpler 
if the tests are run on a windows server.

## Testing Checklist

Other sections of this document will describe how to use rake on a windows
server to check the style and run the repository test.  This checklist
gives a minimum overview of the things to be tested. The rake tasks
are problmatic at the moment.  They fail on spec tests under ubuntu,
mac/os and windows environments.

*  foodcritc .
*  cookstyle
*  rspec
*  kitchen verify
*  Run the install post-implementation on both mac and windows servers

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

#### Windows

##### Testing the cookbook
    bundle exec rake kitchen:all

Will run the test kitchen integration tests.  These tests use Vagrant
and Virtualbox, which must be installed for the tests to execute.

After converging in a virtual machine, InSpec tests are executed.
This skeleton comes with some basic InSpec tests; refer to
https://www.chef.io/inspec/ for detail on how to create tests.

##### Testing bootstrap.ps1
Use test kitchen to spin up a new VM:
    kitchen create

Then you can test your updated bootstrap.ps1 in the guest VM:
1. Run `powershell` as Administrator
2. `notepad bootstrap.ps1` to make a new file
3. Copy + paste your updated code.
4. You may want to add proxy environment variables at the top, plus the script below to copy them to the system. (Currently chocolatey doesn't honor proxy settings in environment variables.)
5. Run `bootstrap.ps1`

##### Applying Proxy settings
This will copy `http_proxy`, `https_proxy`, and `no_proxy` environment variable settings into the registry and tell the system to reload the settings.

```PowerShell
# This applies settings system-wide based on http_proxy/https_proxy/no_proxy env variables
# See http://blogs.msdn.com/b/aymerics_blog/archive/2013/05/18/scripting-toggle-proxy-server-in-ie-settings-with-powershell.aspx

$internetSettingsRegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
Set-ItemProperty -path $internetSettingsRegistryPath ProxyEnable -value 1
Set-ItemProperty -path $internetSettingsRegistryPath ProxyServer -value "http=$env:http_proxy;https=$env:https_proxy"
Set-ItemProperty -path $internetSettingsRegistryPath ProxyOverride -value $env:no_proxy.Replace(",", ";")

# Wrap a native call to a DLL function for wininet
# See https://msdn.microsoft.com/en-us/library/windows/desktop/aa385114(v=vs.85).aspx
$wininetConnector=@"
[DllImport("wininet.dll")]
public static extern bool InternetSetOption(int hInternet, int dwOption, int lpBuffer, int dwBufferLength);
"@

# Wrap the above code so PowerShell can call it
$wininet = Add-Type -memberDefinition $wininetConnector -passthru -name InternetSettings

# See https://msdn.microsoft.com/en-us/library/windows/desktop/aa385328(v=vs.85).aspx
$INTERNET_OPTION_PROXY_SETTINGS_CHANGED = 95
$wininet::InternetSetOption([IntPtr]::Zero, $INTERNET_OPTION_PROXY_SETTINGS_CHANGED, [IntPtr]::Zero, 0)|out-null

```

#### Mac
To check that the unreleased cookbook converges on a mac follow the steps below. If you want to run this behind a proxy, export these environment variables before you run the commands below.

```bash
export http_proxy=http://myproxy.example.com:1234
export https_proxy=$http_proxy
```

```bash
# run this from the chefdk_bootstrap directory

berks vendor cookbooks
sudo -E chef-client -z -c ./client.rb -o chefdk_bootstrap
```

To test the unreleased bootstrap.rb and cookbook work you can run:
```bash
./test/fixtures/scripts/testboot
```
