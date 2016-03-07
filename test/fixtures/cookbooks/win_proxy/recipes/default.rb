#
# Cookbook Name:: win_proxy
# Recipe:: default
#
# Copyright (c) 2016 Nordstrom, Inc.

include_recipe 'chocolatey'

powershell_script 'Configure Chocolatey proxy' do
  action :run
  code <<-EOH
  choco config set proxy #{ENV['https_proxy']}
  EOH
  only_if { ENV['https_proxy'] }
end
