::Chef::Recipe.send(:include, Windows::Helper)

http_proxy = node['chefdk_bootstrap']['proxy']['http']

if http_proxy
  require 'uri'
  proxy_uri = URI.parse(http_proxy)
  # assign proxy vars to local var here
end

# TODO: include Windows helpers to get locate_sysnative_cmd
powershell_profile = File.join(locate_sysnative_cmd('WindowsPowerShell\v1.0'), 'profile.ps1')

template powershell_profile do
  action :create_if_missing
  source 'global_profile.ps1.erb'
  # variables(
  #   proxy: http_proxy,
  #   proxy_host: proxy_uri.host,
  #   proxy_port: proxy_uri.port
  # )
  only_if { node['chefdk_bootstrap']['powershell']['configure'] }
end
