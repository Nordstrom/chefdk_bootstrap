if node['chefdk_bootstrap']['install_chefdk_julia']
  chef_gem 'chefdk-julia'

  # TODO: add the config to enable julia in knife.rb/config.rb
end
