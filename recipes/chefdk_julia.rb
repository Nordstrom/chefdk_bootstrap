if node['chefdk_bootstrap']['package']['chefdk_julia']
  chef_gem 'chefdk-julia'

  # TODO: Rip out all traces of chef julia
end
