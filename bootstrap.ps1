# Copyright 2015 Nordstrom, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#Requires -Version 3.0

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
  [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    Break
}

$targetChefDk = '0.13.21'
$bootstrapCookbook = 'chefdk_bootstrap'

function promptContinue {
  param ($msg="Chefdk_bootstrap encountered an error")
  $yn = Read-Host "$Msg. Continue? [y|N]"
  if ( $yn -NotLike 'y*' ) {
    Break
  }
}

function die {
  param ($msg="Chefdk_bootstrap encountered an error. Exiting")
  Write-host "$msg."
  Break
}

if ($args[0]) {
  $bootstrapCookbook = $args[0]
}

if ($args[1]) {
  $privateSource = "source '$args[1]'"
}

$userChefDir = Join-Path -path $env:USERPROFILE -childPath 'chef'
$dotChefDKDir = Join-Path -path $env:LOCALAPPDATA -childPath 'chefdk'
$tempInstallDir = Join-Path -path $env:TEMP -childpath 'chefdk_bootstrap'
$berksfilePath = Join-Path -path $tempInstallDir -childPath 'Berksfile'
$chefConfigPath = Join-Path -path $tempInstallDir -childPath 'client.rb'
$omniUrl = "https://omnitruck.chef.io/install.ps1"

# Set HOME to be c:\users\<username> so cookbook gem installs are on the c:\
# drive
$env:HOME = $env:USERPROFILE

$berksfile = @"
source 'https://supermarket.chef.io'
$privateSource

cookbook '$bootstrapCookbook'
"@

$chefConfig = @"
cookbook_path File.join(Dir.pwd, 'berks-cookbooks')
"@

$introduction = @"

### This bootstrap script will:

1. Install the ChefDK version $targetChefDk.
2. Download the chefdk_bootstrap cookbook via Berkshelf
3. Run chef-client to install the rest of the tools you'll need.

"@

Clear-Host

Write-Host $introduction

# create the temporary installation directory
if (!(Test-Path $tempInstallDir -pathType container)) {
  New-Item -ItemType 'directory' -path $tempInstallDir
}

# Write out a local Berksfile for Berkshelf to use
$berksfile | Out-File -FilePath $berksfilePath -Encoding ASCII

# Write out minimal chef-client config file
$chefConfig | Out-File -FilePath $chefConfigPath -Encoding ASCII

# Install ChefDK from chef omnitruck, unless installed already
Write-Host "Checking for installed ChefDK version"
$app = Get-CimInstance -classname win32_product -filter "Name like 'Chef Development Kit%'"
$version = $app.Version
if ( $version -like "$targetChefDk*" ) {
  Write-Host "The ChefDK version $version is already installed."
} else {
  if ( $version -eq $null ) {
    Write-Host "No ChefDK found. Installing the ChefDK version $targetChefDk"
  } else {
    Write-Host "Upgrading the ChefDK from $version to $targetChefDk"
    Write-Host "Uninstalling ChefDK version $version. This might take a while..."
    Invoke-CimMethod -InputObject $app -MethodName Uninstall
    if ( -not $? ) { promptContinue "Error uninstalling ChefDK version $version" }
    if (Test-Path $dotChefDKDir) {
      Remove-Item -Recurse $dotChefDKDir
    }
  }
  if ( $env:http_proxy ) {
    $installScript = Invoke-WebRequest -UseBasicParsing $omniUrl -Proxy $env:http_proxy -ProxyUseDefaultCredentials
    if ( -not $? ) { die "Error downloading $omniUrl using proxy $env:http_proxy." }
  } else {
    $installScript = Invoke-WebRequest -UseBasicParsing $omniUrl
    if ( -not $? ) { die "Error downloading $omniUrl. Do you need to set `$env:http_proxy ?" }
  }
  $installScript | Invoke-Expression
  if ( -not $? ) { die "Error running installation script" }
  Write-Host "Installing ChefDK version $targetChefDk. This might take a while..."
  install -channel stable -project chefdk -version $targetChefDk
  if ( -not $? ) { die "Error installing the ChefDK version $targetChefDk" }
}

# Add ChefDK to the path
$env:Path += ";C:\opscode\chefdk\bin"

Push-Location $tempInstallDir

# Install the bootstrap cookbooks using Berkshelf
$env:BERKSHELF_CHEF_CONFIG = $chefConfigPath
berks vendor
if ( -not $? ) { Pop-Location;  die "Error running berks to download cookbooks." }

# run chef-client (installed by ChefDK) to bootstrap this machine
# Pass optional attributes to chef-client
# This is a temporary interface and will change in 2.0 when we support named parameters (Issue #74)
if ($env:CHEFDK_BOOTSTRAP_JSON_ATTRIBUTES) {
  chef-client -A -z -l error -c $chefConfigPath -o $bootstrapCookbook --json-attributes $env:CHEFDK_BOOTSTRAP_JSON_ATTRIBUTES
}
else {
  chef-client -A -z -l error -c $chefConfigPath -o $bootstrapCookbook
}

if ( -not $? ) { Pop-Location;  die "Error running chef-client." }

# Cleanup
if (Test-Path $tempInstallDir) {
  Remove-Item -Recurse $tempInstallDir
}

Remove-Item env:BERKSHELF_CHEF_CONFIG

Pop-Location

# End message to indicate completion of setup
Write-Host "`n`nCongrats!!! Your workstation is now set up for Chef Development!"
