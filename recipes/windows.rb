include_recipe 'chocolatey'

packages = node['chefdk_bootstrap']['package']

packages.each do |pkg, install|
  include_recipe "#{cookbook_name}::#{pkg}" if install
end

include_recipe "#{cookbook_name}::powershell_profile"
