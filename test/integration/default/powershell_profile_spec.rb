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

# PowerShell profile
describe file('C:/Users/Vagrant/Documents/WindowsPowerShell/Profile.ps1') do
  its('content') { should match(/chef shell-init powershell\s*\|\s*Invoke-Expression/i) }
  its('content') { should match(/Set-PSColors/i) }
  its('content') { should_not match(/Import-Module chef/i) }

  if ENV['http_proxy']
    its('content') { should match(/Set-Proxy/) }
  else
    its('content') { should_not match(/Set-Proxy/) }
  end
end
