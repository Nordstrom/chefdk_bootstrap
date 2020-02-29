# Copyright:: 2015 Nordstrom, Inc.
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

home = Dir.home(ENV['SUDO_USER'] || ENV['USER'])
%W(
  #{home}/.chef
  #{home}/chef
  #{home}/chef/cookbooks
).each do |dir|
  directory dir do
    owner ENV['SUDO_USER'] || ENV['USER']
  end
end

include_recipe 'homebrew'
include_recipe 'homebrew::cask'

packages = node['chefdk_bootstrap']['package']

packages.each do |pkg, install|
  include_recipe "#{cookbook_name}::#{pkg}" if install
end
