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

RSpec.describe 'chefdk_bootstrap::powershell_profile' do
  include_context 'windows_mocks'

  context 'When cookbook proxy attributes are not set' do
    include_context 'windows_2012'

    before do
      %w(http_proxy https_proxy no_proxy).each do |proxy_var|
        ENV.delete(proxy_var)
      end
    end

    it 'creates the PowerShell AllUsersAllHosts profile if missing' do
      expect(windows_chef_run).to create_template_if_missing('C:\WINDOWS\sysnative\WindowsPowerShell\v1.0/profile.ps1')
    end

    it "the rendered profile doesn't contain proxy env vars" do
      expect(windows_chef_run)
        .to render_file('C:\WINDOWS\sysnative\WindowsPowerShell\v1.0/profile.ps1')
          .with_content { |content|
            expect(content).to_not include('$env:http_proxy')
          }
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

    let(:all_users_profile) { 'C:\WINDOWS\sysnative\WindowsPowerShell\v1.0/profile.ps1' }

    it 'the rendered profile sets the http_proxy env var' do
      expect(windows_chef_run)
        .to render_file(all_users_profile)
        .with_content("$env:http_proxy = 'http://myproxy.example.com:1234'")
    end

    it 'the rendered profile sets the https_proxy env var' do
      expect(windows_chef_run)
        .to render_file(all_users_profile)
        .with_content('$env:https_proxy = $env:http_proxy')
    end

    it 'the rendered profile sets the no_proxy env var' do
      expect(windows_chef_run)
        .to render_file(all_users_profile)
        .with_content("$env:no_proxy = 'example.com,localhost,127.0.0.1'")
    end
  end
end
