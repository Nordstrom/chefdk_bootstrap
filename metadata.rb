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

name             'chefdk_bootstrap'
maintainer       'Nordstrom, Inc.'
maintainer_email 'techcheftm@nordstrom.com'
license          'Apache-2.0'
description      'Bootstrap a developer workstation for local Chef development using the ChefDK'
version          '2.4.1'

supports         'windows'
supports         'mac_os_x'

# TODO: If the chef-atom project merges the custom resource change
# use the chef-atom cookbook and removed the parts of chef-atom
# embedded in this cookbook.
# while atom is embedded.  depends          'atom', '~> 0.2.0'
depends          'chef_ca', '0.1.1'
depends          'chocolatey', '~> 1.0'
depends          'git', '~> 8.0'
depends          'homebrew', '~> 4.3'
depends          'line', '~> 1.0'
depends          'vagrant', '~> 0.9'
depends          'windows', '~> 3.4'

# temporary while atom is embedded
depends          'apt', '~> 6.1'

source_url       'https://github.com/Nordstrom/chefdk_bootstrap'
issues_url       'https://github.com/Nordstrom/chefdk_bootstrap/issues'
chef_version     '> 12.5.0'
