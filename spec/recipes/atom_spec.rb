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
RSpec.describe 'chefdk_bootstrap::atom' do
  context 'On a Windows machine' do
    include_context 'windows_2012'

    it "downloads the Atom setup package to Chef's file_cache_path" do
      expect(windows_chef_run).to create_remote_file(
        'c:/chef/cache/AtomSetup.exe').with(
          source: 'https://atom.io/download/windows',
          backup: false
        )
    end

    it 'installs the downloaded package' do
      expect(windows_chef_run).to install_windows_package('Atom').with(
        installer_type: :custom,
        options: '/silent'
      )
    end
  end

  context 'On a Mac' do
    include_context 'mac_os_x'

    it 'installs Atom via homebrew_cask' do
      expect(mac_os_x_chef_run).to install_homebrew_cask('atom')
    end
  end
end
