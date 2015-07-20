case node['platform_family']
when 'windows'
  chocolatey 'virtualbox'
when 'mac_os_x'
  homebrew_cask 'virtualbox'
end
