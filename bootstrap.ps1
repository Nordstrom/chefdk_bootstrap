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
#

$bootstrapCookbook = 'chefdk_bootstrap'

if ($args[0]) {
  $bootstrapCookbook = $args[0]
}

if ($args[1]) {
  $privateSource = "source '$args[1]'"
}

$chefDkSource = 'https://www.chef.io/chef/download-chefdk?p=windows&pv=2008r2&m=x86_64&v=latest'

$userChefDir = Join-Path -path $env:USERPROFILE -childPath 'chef'
$berksfilePath = Join-Path -path $userChefDir -childPath 'Berksfile'
$chefConfigPath = Join-Path -path $userChefDir -childPath 'client.rb'

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

1. Install the latest ChefDK package.
2. Create a `chef` directory in your user profile (home) directory.
3. Download the `chefdk_bootstrap` cookbook via Berkshelf
4. Run `chef-client` to install the rest of the tools you'll need.

"@

Clear-Host

Write-Host $introduction

# create the chef directory
if (!(Test-Path $userChefDir -pathType container)) {
  New-Item -ItemType 'directory' -path $userChefDir
}

# Write out a local Berksfile for Berkshelf to use
$berksfile | Out-File -FilePath $berksfilePath -Encoding ASCII

# Write out minimal chef-client config file
$chefConfig | Out-File -FilePath $chefConfigPath -Encoding ASCII

# Install ChefDK .msi package from Chef
Write-Host 'Installing ChefDK...'
Start-Process -Wait -FilePath msiexec.exe -ArgumentList /qb, /i, $chefDkSource

# Add ChefDK to the path
$env:Path += ";C:\opscode\chefdk\bin"

Set-Location $userChefDir

# Install the bootstrap cookbooks using Berkshelf
berks vendor

# run chef-client (installed by ChefDK) to bootstrap this machine
chef-client -A -z -l error -c $chefConfigPath -o $bootstrapCookbook

# Cleanup
if (Test-Path $berksfilePath) {
  Remove-Item $berksfilePath
}

if (Test-Path "$berksfilePath.lock") {
  Remove-Item "$berksfilePath.lock"
}

if (Test-Path $chefConfigPath) {
  Remove-Item $chefConfigPath
}

if (Test-Path nodes) {
  Remove-Item -Recurse nodes
}

if (Test-Path berks-cookbooks) {
  Remove-Item -Recurse berks-cookbooks
}

# End message to indicate completion of setup
Write-Host "`n`nCongrats!!! Your workstation is now set up for Chef Development!"
