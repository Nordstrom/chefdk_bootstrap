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

directory 'C:\opscode\chefdk\modules\chefdk_bootstrap'

template 'C:\opscode\chefdk\modules\chefdk_bootstrap\chefdk_bootstrap.psm1' do
  source 'chefdk_bootstrap.psm1.erb'
end

current_user_all_hosts_profile_dir = win_friendly_path(File.join(Dir.home, 'Documents\WindowsPowerShell'))
current_user_all_hosts_profile = win_friendly_path(File.join(current_user_all_hosts_profile_dir, 'Profile.ps1'))

directory current_user_all_hosts_profile_dir

file current_user_all_hosts_profile do
  action :create_if_missing
end

append_if_no_line 'Show leading comment to help user' do
  path lazy { current_user_all_hosts_profile }
  line '# See chefdk_bootstrap PowerShell Module in C:\opscode\chefdk\modules\chefdk_bootstrap'
end

append_if_no_line 'Set proxy env vars in Current User profile' do
  path lazy { current_user_all_hosts_profile }
  line 'Add-Proxy'
  only_if { node['chefdk_bootstrap']['proxy']['http'] }
end

append_if_no_line 'Setup ChefDK environment for PowerShell' do
  path lazy { current_user_all_hosts_profile }
  line 'Enable-ChefDKBootstrap'
end
