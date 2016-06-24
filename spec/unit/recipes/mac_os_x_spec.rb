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

RSpec.describe 'chefdk_bootstrap::mac_os_x' do
  # TODO: move this into the shared_nodes shared context
  let(:mac_os_x_chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'mac_os_x',
      version: '10.10'
    ) do |node|
      node.set['vagrant']['checksum'] = 'abc123'
    end
  end

  before do
    allow(Dir).to receive(:home).and_return('/Users/doug')
    allow(ENV).to receive(:[]).with('SUDO_USER').and_return('doug')
    allow(ENV).to receive(:[]).with('USER').and_return('doug')
    allow(ENV).to receive(:[]).and_call_original
    stub_command('which git')
  end

  it 'creates /usr/local and sets the owner to SUDO_USER when specified' do
    # use call original as per http://www.relishapp.com/rspec/rspec-mocks/v/3-3/docs/configuring-responses/calling-the-original-implementation#%60and-call-original%60-can-configure-a-default-response-that-can-be-overriden-for-specific-args
    allow(ENV).to receive(:[]).with('SUDO_USER').and_return('serena')
    mac_os_x_chef_run.converge(described_recipe)
    expect(mac_os_x_chef_run).to create_directory('/usr/local').with(
      owner: 'serena'
    )
  end

  it 'creates /usr/local and sets the owner to USER when SUDO_USER is not specified' do
    # use call original as per http://www.relishapp.com/rspec/rspec-mocks/v/3-3/docs/configuring-responses/calling-the-original-implementation#%60and-call-original%60-can-configure-a-default-response-that-can-be-overriden-for-specific-args
    allow(ENV).to receive(:[]).with('SUDO_USER').and_return(nil)
    allow(ENV).to receive(:[]).with('USER').and_return('doug')
    mac_os_x_chef_run.converge(described_recipe)
    expect(mac_os_x_chef_run).to create_directory('/usr/local').with(
      owner: 'doug'
    )
  end

  %w(
    /Users/doug/.chef
    /Users/doug/chef
    /Users/doug/chef/cookbooks
  ).each do |directory|
    it "creates directory #{directory}" do
      mac_os_x_chef_run.converge(described_recipe)
      expect(mac_os_x_chef_run).to create_directory(directory)
    end
  end

  context 'includes recipes' do
    before do
      mac_os_x_chef_run.converge(described_recipe)
    end

    recipes = %w(
      homebrew
      homebrew::cask
      chefdk_bootstrap::virtualbox
      chefdk_bootstrap::vagrant
      chefdk_bootstrap::atom
      chefdk_bootstrap::git
      chefdk_bootstrap::iterm2
      chefdk_bootstrap::bash_profile
    )

    recipes.each do |recipe|
      it "includes the #{recipe} recipe" do
        expect(mac_os_x_chef_run).to include_recipe(recipe)
      end
    end
  end
end
