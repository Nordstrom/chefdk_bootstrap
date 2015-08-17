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
  context 'On a Windows machine' do
    let(:windows_node) do
      ChefSpec::ServerRunner.new(
        platform: 'windows',
        version: '2012R2'
      )
    end

    before do
      windows_node.converge(described_recipe)
    end

    it 'converges successfully' do
      expect(windows_node).to include_recipe(described_recipe)
    end

    it 'includes the platform specific entry point recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::windows')
    end
  end

  context 'On a Mac OS X machine' do
    let(:mac_os_x_node) do
      ChefSpec::ServerRunner.new(
        platform: 'mac_os_x',
        version: '10.10'
      )
    end

    before do
      stub_command('which git')
      mac_os_x_node.converge(described_recipe)
    end

    it 'converges successfully' do
      expect(mac_os_x_node).to include_recipe(described_recipe)
    end

    it 'includes the platform specific entry point recipe' do
      expect(mac_os_x_node).to include_recipe('chefdk_bootstrap::mac_os_x')
    end
  end
end
