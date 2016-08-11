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

RSpec.describe 'chefdk_bootstrap::default' do
  context 'On a Windows machine', win_bootstrap: true do
    include_context 'windows_2012'
    include_context 'windows_mocks'

    it 'includes the platform specific entry point recipe' do
      expect(windows_chef_run).to include_recipe('chefdk_bootstrap::windows')
    end

    it 'includes the chefdk-julia recipe' do
      expect(windows_chef_run).to include_recipe('chefdk_bootstrap::chefdk_julia')
    end
  end

  context 'On a Mac OS X machine' do
    include_context 'mac_os_x'

    before do
      allow(Dir).to receive(:home).and_return('/Users/doug')
      allow(ENV).to receive(:[]).with('USER').and_return('doug')
      allow(ENV).to receive(:[]).and_call_original
      stub_command('which git')
    end

    it 'converges successfully' do
      expect(mac_os_x_chef_run).to include_recipe(described_recipe)
    end

    it 'includes the platform specific entry point recipe' do
      expect(mac_os_x_chef_run).to include_recipe('chefdk_bootstrap::mac_os_x')
    end

    it 'includes the chefdk-julia recipe' do
      expect(mac_os_x_chef_run).to include_recipe('chefdk_bootstrap::chefdk_julia')
    end
  end
end
