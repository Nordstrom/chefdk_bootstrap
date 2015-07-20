case node['platform_family']
when 'windows'
  chocolatey 'vagrant'
when 'mac_os_x'
  homebrew_cask 'vagrant'
end
