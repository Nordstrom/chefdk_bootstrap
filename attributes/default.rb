# Copyright 2015, 2018 Nordstrom, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['chefdk_bootstrap']['atom']['source_url'] =
  value_for_platform_family(
    'mac_os_x' => 'https://atom.io/download/mac',
    'windows' => 'https://atom.io/download/windows'
  )

# common things to install
default['chefdk_bootstrap']['package'].tap do |install|
  install['atom'] = true
  install['chef_ca'] = false
  install['virtualbox'] = true
  install['vagrant'] = true
  install['git'] = true
  install['chefdk_julia'] = false
  install['kitchen_proxy'] = true
  install['gitconfig'] = false
end

# No virtual box on vm
default['chefdk_bootstrap']['package']['virtualbox'] = false if node['virtualization']['system']['role'] == 'guest'

# platform specific
case node['platform_family']
when 'windows'
  default['chefdk_bootstrap']['package'].tap do |install|
    install['kdiff3'] = true
    install['gitextensions'] = true
    install['poshgit'] = true
    install['conemu'] = true
  end
when 'mac_os_x'
  default['chefdk_bootstrap']['package'].tap do |install|
    install['iterm2'] = true
    install['bash_profile'] = true
  end
end

default['chefdk_bootstrap']['gitconfig'] = {
  'core.editor' => { value: 'atom --wait' },
  'core.autocrlf' => { value: 'True' },
  'alias.co' => { value: 'checkout' },
  'alias.br' => { value: 'branch' },
  'alias.ci' => { value: 'commit' },
  'alias.st' => { value: 'status' },
  'alias.lol' => { value: "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit" },
  'push.default' => { value: 'simple' },
}

default['chefdk_bootstrap']['gitconfig']['credential.helper'] = { value: 'osxkeychain' } if platform_family?('mac_os_x')
default['chefdk_bootstrap']['gitconfig']['user.name'] = { value: ENV['GITUSERNAME'] } if ENV['GITUSERNAME']
default['chefdk_bootstrap']['gitconfig']['user.email'] = { value: ENV['GITUSEREMAIL'] } if ENV['GITUSEREMAIL']

# whether to mess with PowerShell settings
default['chefdk_bootstrap']['powershell']['configure'] = true

# Enable cmd line tools like git, curl, Stove to work through a proxy server.
# Override these to set http_proxy, https_proxy, and no_proxy env vars
default['chefdk_bootstrap']['proxy']['http'] = ENV['http_proxy'] # 'http://myproxy.example.com:1234'
# Skip the proxy for these domains and IPs. This should be a comma-separated string
default['chefdk_bootstrap']['proxy']['no_proxy'] = ENV['no_proxy'] # 'example.com,localhost,127.0.0.1'

default['chefdk_bootstrap']['virtualbox']['source'] = 'http://download.virtualbox.org/virtualbox/5.2.8/VirtualBox-5.2.8-121009-OSX.dmg'
default['chefdk_bootstrap']['virtualbox']['checksum'] = '97764ad37c5fafdeccecfb660ce056f625e9048890af772befe0330ed2def1d8'

# Default Atom plugins
default['atom']['packages'] = %w(language-powershell linter linter-cookstyle linter-erb linter-foodcritic linter-rubocop merge-conflicts rubocop-auto-correct)
