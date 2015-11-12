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

RSpec.describe 'chefdk_bootstrap::windows' do
  before do
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        @vpd_setting = mocks.verify_partial_doubles?
        mocks.verify_partial_doubles = false
      end
    end

    allow_any_instance_of(Chef::Resource::RemoteFile).to receive(
      :chocolatey_installed?).and_return(false)
  end

  after do
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        mocks.verify_partial_doubles = @vpd_setting
      end
    end
  end

  context 'default attributes' do
    cached(:windows_node) do
      ChefSpec::SoloRunner.new(
        platform: 'windows',
        version: '2012R2'
      ).converge(described_recipe)
    end

    it 'includes the chocolatey recipe' do
      expect(windows_node).to include_recipe('chocolatey')
    end

    it 'includes atom recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::atom')
    end

    it 'includes virtualbox recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::virtualbox')
    end

    it 'includes vagrant recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::vagrant')
    end

    it 'includes git recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::git')
    end

    it 'includes kdiff3 recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::kdiff3')
    end

    it 'includes gitextensions recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::gitextensions')
    end
  end

  context 'with attribute overrides' do
    cached(:windows_node) do
      ChefSpec::SoloRunner.new(
        platform: 'windows',
        version: '2012R2'
      ) do |node|
        node.set['chefdk_bootstrap']['package']['atom'] = false
        node.set['chefdk_bootstrap']['package']['gitextensions'] = false
      end.converge(described_recipe)
    end

    it 'does not include atom recipe' do
      expect(windows_node).to_not include_recipe('chefdk_bootstrap::atom')
    end

    it 'does not include gitextensions recipe' do
      expect(windows_node).to_not include_recipe('chefdk_bootstrap::gitextensions')
    end

    it 'includes virtualbox recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::virtualbox')
    end

    it 'includes kdiff3 recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::kdiff3')
    end
  end
end
