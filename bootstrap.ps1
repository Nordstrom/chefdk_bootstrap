$chefDkSource = 'https://www.chef.io/chef/download-chefdk?p=windows&pv=2008r2&m=x86_64&v=latest'
$bootstrapCookbook = 'chefdk_bootstrap'

$userChefDir = Join-Path -path $env:USERPROFILE -childPath 'chef'
$berksfilePath = Join-Path -path $userChefDir -childPath 'Berksfile'
$chefConfigPath = Join-Path -path $userChefDir -childPath 'bootstrap.rb'

$berksfile = @"
source 'https://supermarket.chef.io'

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

Write-Host $introduction

# create the chef directory
if (!(Test-Path $userChefDir -pathType container)) {
  New-Item -ItemType 'directory' -path $userChefDir
}

Set-Location $userChefDir

# Write out a local Berksfile for Berkshelf to use
$berksfile | Out-File -FilePath $berksfilePath -Encoding ASCII

# Write out minimal chef-client config file
$chefConfig | Out-File -FilePath $chefConfigPath -Encoding ASCII

# Install ChefDK .msi package from Chef
Write-Host 'Installing ChefDK...'
Start-Process -Wait -FilePath msiexec.exe -ArgumentList /qb, /i, $chefDkSource

# Add ChefDK to the path
$env:Path += ";c:\opscode\chefdk\bin"

# Install the bootstrap cookbooks using Berkshelf
berks vendor

# run chef-client (installed by ChefDK) to bootstrap this machine
chef-client -A -z -l error -c $chefConfigPath -o $bootstrapCookbook

# Cleanup
rm $berksfilePath
rm "$berksfilePath.lock"
rm $chefConfigPath
rm -Recurse nodes
rm -Recurse berks-cookbooks
