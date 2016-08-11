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

username = ENV['APPVEYOR'] ? ENV['machine_user'] : 'vagrant'

# PowerShell profile
describe file("C:/Users/#{username}/Documents/WindowsPowerShell/Profile.ps1") do
  its('content') { should match(/# See chefdk_bootstrap PowerShell Module/) }
  its('content') { should match(/Enable-ChefDKBootstrap/) }

  if ENV['http_proxy']
    its('content') { should match(/Add-Proxy/) }
  else
    its('content') { should_not match(/Add-Proxy/) }
  end
end

# Make sure ssh is on the path
describe command('ssh') do
  it { should exist }
end
