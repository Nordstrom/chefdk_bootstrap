# Copyright 2015, 2018 Nordstrom, Inc.
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

new-module -name ChefDKBootstrap -scriptblock {
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

function Install-Project {
  Param(
    [string] $version,
    [string] $json_attributes
  )

  if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
      Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
      Break
  }

  # Set targetChefDk to latest version from metadata URL
  $metadataURL = "https://omnitruck.chef.io/stable/chefdk/metadata?p=windows&pv=2012r2&m=x86_64&v=latest"

  if ( $env:http_proxy ) {
    $getMetadata = Invoke-WebRequest -UseBasicParsing $metadataURL -Proxy $env:http_proxy -ProxyUseDefaultCredentials
    if ( -not $? ) { die "Error downloading $metadataURL using proxy $env:http_proxy." }
  } else {
    $getMetadata = Invoke-WebRequest -UseBasicParsing $metadataURL
    if ( -not $? ) { die "Error downloading $metadataURL. Do you need to set `$env:http_proxy ?" }
  }

  $latest_info = $getMetadata.Content
  $CHEFDK_LATEST_PATTERN = "version\s(\d{1,2}\.\d{1,2}\.\d{1,2})"
  $targetChefDk = [regex]::match($latest_info, $CHEFDK_LATEST_PATTERN).Groups[1].Value

  # Get command line arguments set
  if ($version) {
    $targetChefDk = $version
  }

  $bootstrapCookbook = 'chefdk_bootstrap'

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

  cookbook '$bootstrapCookbook', '2.4.1'
"@

  $chefConfig = @"
  cookbook_path File.join(Dir.pwd, 'berks-cookbooks')
"@

  $introduction = @"

  ### This bootstrap script will:

  1. Install the ChefDK version $targetChefDk.
  2. Download the $bootstrapCookbook cookbook via Berkshelf
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
  $installedVersion = $app.Version
  if ( $installedVersion -like "$targetChefDk*" ) {
    Write-Host "The ChefDK version $installedVersion is already installed."
  } else {
    if ( $installedVersion -eq $null ) {
      Write-Host "No ChefDK found. Installing the ChefDK version $targetChefDk"
    } else {
      Write-Host "Upgrading the ChefDK from $installedVersion to $targetChefDk"
      Write-Host "Uninstalling ChefDK version $installedVersion. This might take a while..."
      Invoke-CimMethod -InputObject $app -MethodName Uninstall
      if ( -not $? ) { promptContinue "Error uninstalling ChefDK version $installedVersion" }
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
  # Pass optional named parameter json_attributes to chef-client
  if ($json_attributes -ne "") {
    chef-client -A -z -l error -c $chefConfigPath -o $bootstrapCookbook --json-attributes $json_attributes
  }
  else {
    chef-client -A -z -l error -c $chefConfigPath -o $bootstrapCookbook
  }

  if ( -not $? ) { Pop-Location;  die "Error running chef-client." }

  Pop-Location

  # Cleanup
  if (Test-Path $tempInstallDir) {
    Remove-Item -Recurse $tempInstallDir
  }

  Remove-Item env:BERKSHELF_CHEF_CONFIG

  # End message to indicate completion of setup
  Write-Host "`n`nCongrats!!! Your workstation is now set up for Chef Development!"
}
set-alias install -value Install-Project
export-modulemember -function 'Install-Project' -alias 'install'
}
