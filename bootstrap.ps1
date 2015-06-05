$chefDkSource = 'https://www.chef.io/chef/download-chefdk?p=windows&pv=2008r2&m=x86_64&v=latest'
$bootstrapCookbook = 'chefdk_bootstrap'
$userChefDir = Join-Path -path $env:USERPROFILE -childPath 'chef'

$berksfile = @"
source 'https://supermarket.chef.io'

cookbook '$bootstrapCookbook'
"@

# Install ChefDK .msi package from Chef
Start-Process -Wait -FilePath msiexec.exe -ArgumentList /qb, /i, $chefDkSource

# create the chef directory
if (!(Test-Path $userChefDir -pathType container)) {
  New-Item -ItemType 'directory' -path $userChefDir
}

Set-Location $userChefDir

# Write out a local Berksfile for Berkshelf to use
$berksfile | Out-File -FilePath .\Berksfile -Encoding ASCII

# Install the bootstrap cookbooks to .\cookbooks using Berkshelf
# If we find an existing .\cookbooks directory, bail out because Berkshelf
# will overwrite the cookbooks directory without asking.
if (Test-Path .\cookbooks -pathType container) {
  throw 'Found existing .\cookbooks directory.
    Please rename or delete the .\cookbooks directory and rerun this script.'
}
else {
  berks vendor cookbooks
}

# run chef-client (installed by ChefDK) to bootstrap this machine
# it will look for a .\cookbooks directory in the current directory
chef-client -A -z -l error -o $bootstrapCookbook
