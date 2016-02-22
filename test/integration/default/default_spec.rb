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

require 'spec_helper'

# FIXME: ServerSpec fails when "Installing Busser plugins: busser-serverspec"
# because Test-kitchen assumes chef-client is installed instead of ChefDK
# and expects ruby.exe to be in the location where chef-client installs it.
describe command('vagrant -v') do
  its(:exit_status) { should eq(0) }
end
