extend Windows::Helper

powershell_profile = File.join(locate_sysnative_cmd('WindowsPowerShell\v1.0'), 'profile.ps1')

template powershell_profile do
  action :create_if_missing
  source 'global_profile.ps1.erb'

  only_if { node['chefdk_bootstrap']['powershell']['configure'] }
end
