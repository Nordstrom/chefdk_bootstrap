case node['platform_family']
when 'windows'
  git_client node['git']['display_name']

  chocolatey 'git-credential-winstore'
  chocolatey 'poshgit'
when 'mac_os_x'
  package 'git'
end
