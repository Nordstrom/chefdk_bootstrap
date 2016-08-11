# Copyright 2016 Nordstrom, Inc.
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

bash_profile = File.join(Dir.home, '.bash_profile')

file bash_profile do
  action :create_if_missing
end

append_if_no_line 'Set http_proxy var in bash_profile' do
  path bash_profile
  line "export http_proxy=#{node['chefdk_bootstrap']['proxy']['http']}"
  only_if { node['chefdk_bootstrap']['proxy']['http'] }
end

append_if_no_line 'Set https_proxy var in bash_profile' do
  path bash_profile
  line 'export https_proxy=$http_proxy'
  only_if { node['chefdk_bootstrap']['proxy']['http'] }
end

append_if_no_line 'Set no_proxy var in bash_profile' do
  path bash_profile
  line "export no_proxy='#{node['chefdk_bootstrap']['proxy']['no_proxy']}'"
  only_if { node['chefdk_bootstrap']['proxy']['no_proxy'] }
end
