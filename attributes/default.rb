default['chocolatey']['upgrade'] = false

# What to install
default['chefdk_bootstrap']['package'].tap do |install|
  install['atom'] = true
  install['putty'] = true
  install['kdiff3'] = true
  install['virtualbox'] = true
  install['vagrant'] = true
  install['git'] = true
  install['gitextensions'] = true
end

# whether to mess with PowerShell settings
default['chefdk_bootstrap']['powershell']['configure'] = true
