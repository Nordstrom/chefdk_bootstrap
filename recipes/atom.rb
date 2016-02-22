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
  package 'Atom' do
    source node['chefdk_bootstrap']['atom']['source_url']
    remote_file_attributes(
      backup: false
    )
    installer_type :custom
    options '/silent'
  end
when 'mac_os_x'
  homebrew_cask 'atom'
end
