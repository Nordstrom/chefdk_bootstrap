# Copyright 2018 Nordstrom, Inc.
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

return unless shell_out('git config --global -l').stdout.chomp.empty?

node['chefdk_bootstrap']['gitconfig'].each do |key, attrs|
  git_config key do
    value   attrs[:value]
    scope   attrs[:scope] || 'global'
    options attrs[:options] || '--add'
  end
end
