# Install a kitchen configuration file to pass through proxy settings
# (only if there's a proxy at setup time and only if the file doesn't exist)

directory File.join(Dir.home, '.kitchen')

cookbook_file File.join(Dir.home, '.kitchen', 'config.yml') do
  source 'kitchen.config.yml'
  action :create_if_missing
  only_if { node['chefdk_bootstrap']['proxy']['http'] }
end
