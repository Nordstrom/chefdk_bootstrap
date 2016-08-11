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

RSpec.describe 'chefdk_bootstrap::powershell_profile', win_bootstrap: true do
  include_context 'windows_mocks'

  before do
    allow(Dir).to receive(:home).and_return('C:\Users\bobbie')
  end

  let(:current_user_all_hosts_profile) { 'C:\Users\bobbie\Documents\WindowsPowerShell\Profile.ps1' }

  context 'When cookbook proxy attributes are not set' do
    include_context 'windows_2012'

    before do
      %w(http_proxy https_proxy no_proxy).each do |proxy_var|
        ENV.delete(proxy_var)
      end
    end

    it 'creates the chefdk_bootstrap PowerShell module directory' do
      expect(windows_chef_run).to create_directory('C:\opscode\chefdk\modules\chefdk_bootstrap')
    end

    it 'creates the C:\opscode\chefdk\modules\chefdk_bootstrap\chefdk_bootstrap.psm1 PowerShell module' do
      expect(windows_chef_run).to create_template('C:\opscode\chefdk\modules\chefdk_bootstrap\chefdk_bootstrap.psm1')
    end

    it 'creates the PowerShell CurrentUserAllHosts profile if missing' do
      expect(windows_chef_run).to create_file_if_missing(current_user_all_hosts_profile)
    end

    it "doesn't setup proxy env vars" do
      expect(windows_chef_run).to_not edit_append_if_no_line('Set proxy env vars in Current User profile')
    end

    it "sets up the ChefDK environment via 'chef shell-init'" do
      expect(windows_chef_run).to edit_append_if_no_line('Setup ChefDK environment for PowerShell').with(
        path: current_user_all_hosts_profile,
        line: 'Enable-ChefDKBootstrap'
      )
    end
  end

  context 'When cookbook proxy `http` and `no_proxy` attributes are set' do
    # TODO: move this into the shared_nodes shared context
    cached(:windows_chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'windows', version: '2012R2'
      ) do |node|
        node.set['chefdk_bootstrap']['proxy']['http'] = 'http://myproxy.example.com:1234'
        node.set['chefdk_bootstrap']['proxy']['no_proxy'] = 'example.com,localhost,127.0.0.1'
      end.converge(described_recipe)
    end

    it 'the rendered profile sets the http_proxy env var' do
      expect(windows_chef_run).to edit_append_if_no_line('Set proxy env vars in Current User profile').with(
        path: current_user_all_hosts_profile,
        line: 'Add-Proxy'
      )
    end
  end
end
