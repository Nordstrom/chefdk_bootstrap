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
RSpec.describe 'chefdk_bootstrap::bash_profile' do
  before do
    allow(Dir).to receive(:home).and_return('/Users/bobbie')
  end

  let(:bash_profile) { '/Users/bobbie/.bash_profile' }

  context 'When cookbook proxy attributes are not set' do
    include_context 'mac_os_x'

    before do
      %w(http_proxy https_proxy no_proxy).each do |proxy_var|
        ENV.delete(proxy_var)
      end
    end

    it 'creates the bash_profile if it is missing' do
      expect(mac_os_x_chef_run).to create_file_if_missing(bash_profile)
    end

    it "doesn't setup proxy env vars" do
      expect(mac_os_x_chef_run).to_not edit_append_if_no_line('Set proxy env cars in bash_profile')
    end
  end

  context 'When cookbook proxy `http` and `no_proxy` attributes are set' do
    # TODO: move this into the shared_nodes shared context
    cached(:mac_os_x_chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'mac_os_x',
        version: '10.10',
        file_cache_path: '/var/chef/cache'
      ) do |node|
        node.set['chefdk_bootstrap']['proxy']['http'] = 'http://myproxy.example.com:1234'
        node.set['chefdk_bootstrap']['proxy']['no_proxy'] = 'example.com,localhost,127.0.0.1'
      end.converge(described_recipe)
    end

    it 'the rendered profile sets the http_proxy env var' do
      expect(mac_os_x_chef_run).to edit_append_if_no_line('Set http_proxy var in bash_profile').with(
        path: bash_profile,
        line: 'export http_proxy=http://myproxy.example.com:1234'
      )
    end

    it 'the rendered profile sets the https_proxy env var' do
      expect(mac_os_x_chef_run).to edit_append_if_no_line('Set https_proxy var in bash_profile').with(
        path: bash_profile,
        line: 'export https_proxy=$http_proxy'
      )
    end

    it 'the rendered profile sets the no_proxy env var' do
      expect(mac_os_x_chef_run).to edit_append_if_no_line('Set no_proxy var in bash_profile').with(
        path: bash_profile,
        line: "export no_proxy='example.com,localhost,127.0.0.1'"
      )
    end
  end
end
