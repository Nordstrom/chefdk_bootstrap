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

extend Windows::Helper

# PowerShell AllUsersAllHosts profile
powershell_profile = File.join(locate_sysnative_cmd('WindowsPowerShell\v1.0'), 'profile.ps1')

template powershell_profile do
  action :create_if_missing
  source 'global_profile.ps1.erb'
end
