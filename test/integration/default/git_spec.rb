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

describe command('git --version') do
  # git version 2.8.1.windows.1
  its(:stdout) { should match(/git version \d+\.\d+\.\d+/) }
end

describe command('git config --get credential.helper') do
  # verify git-credential-manager-for-windows is configured correctly
  its(:stdout) { should match(/manager/) }
end

git_credential_mgr = File.join(
  '$env:LOCALAPPDATA',
  'Programs\Microsoft Git Credential Manager for Windows',
  'git-credential-manager.exe'
)

describe command("& \"#{git_credential_mgr}\" version") do
  its(:exit_status) { should eq(0) }
  its(:stderr) { should eq '' } unless ENV['APPVEYOR']
  its(:stderr) { should_not include('CommandNotFound') } if ENV['APPVEYOR']
end

# PoshGit
# describe powershell('test-path Function:\PoshGitPrompt') do
#   its(:stdout) { should match(/^True\R/) }
# end
