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

case node['platform_family']
when 'windows'
  # chocolatey_package %w(git git-credential-manager-for-windows poshgit)
  chocolatey_package 'git' do
  end
  chocolatey_package 'git-credential-manager-for-windows' do
  end
  # chocolatey_package 'poshgit'
when 'mac_os_x'
  package 'git'
end
