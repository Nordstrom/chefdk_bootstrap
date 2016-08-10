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
RSpec.describe 'chefdk_bootstrap::conemu' do
  context 'On a Windows machine', win_bootstrap: true do
    include_context 'windows_2012'
    include_context 'windows_mocks'

    it 'installs ConEmu via chocolatey when the recipe is not running inside ConEmu' do
      expect(windows_chef_run).to install_chocolatey_package('conemu')
    end
  end
end
