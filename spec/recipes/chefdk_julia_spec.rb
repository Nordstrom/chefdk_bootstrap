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

RSpec.describe 'chefdk_bootstrap::chefdk_julia' do
  context 'by default' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    it "doesn't install the chefdk-julia gem" do
      expect(chef_run).to_not install_chef_gem('chefdk-julia')
    end
  end

  context 'when the [\'chefdk_bootstrap\'][\'package\'][\'chefdk_julia\'] attribute is true' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['chefdk_bootstrap']['package']['chefdk_julia'] = true
      end.converge(described_recipe)
    end

    it 'installs the chefdk-julia gem' do
      expect(chef_run).to install_chef_gem('chefdk-julia')
    end
  end
end
