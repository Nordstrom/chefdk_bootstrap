default['chocolatey']['upgrade'] = false

default['chefdk_bootstrap']['atom']['source_url'] =
  value_for_platform_family(
    'mac_os_x' => 'https://atom.io/download/mac',
    'windows' => 'https://atom.io/download/windows'
  )

# common things to install
default['chefdk_bootstrap']['package'].tap do |install|
  install['atom'] = true
  install['virtualbox'] = true
  install['vagrant'] = true
  install['git'] = true
end

# windows specific
case node['platform_family']
when 'windows'
  default['chefdk_bootstrap']['package'].tap do |install|
    install['kdiff3'] = true
    install['gitextensions'] = true
  end
when 'mac_os_x'
  default['chefdk_bootstrap']['package'].tap do |install|
    install['iterm2'] = true
  end
end

# whether to mess with PowerShell settings
default['chefdk_bootstrap']['powershell']['configure'] = true

# Enable cmd line tools like git, curl, Stove to work through a proxy server.
# Override these to set http_proxy, https_proxy, and no_proxy env vars
default['chefdk_bootstrap']['proxy']['http'] = ENV['http_proxy'] # 'http://myproxy.example.com:1234'
# Skip the proxy for these domains and IPs. This should be a comma-separated string
default['chefdk_bootstrap']['proxy']['no_proxy'] = ENV['no_proxy'] # 'example.com,localhost,127.0.0.1'
