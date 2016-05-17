# Copyright 2015 Nordstrom, Inc.
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
license          'Apache 2.0'
description      'Bootstrap a developer workstation for local Chef development using the ChefDK'
version          '1.9.0'

supports 'windows'
supports 'mac_os_x'

depends 'atom', '~> 0.2.0'
depends 'chocolatey', '~> 1.0'
depends 'homebrew', '~> 2.0'
depends 'line', '~> 0.6'
depends 'vagrant', '~> 0.5'
depends 'windows', '~> 1.39'

source_url 'https://github.com/Nordstrom/chefdk_bootstrap'
issues_url 'https://github.com/Nordstrom/chefdk_bootstrap/issues'
