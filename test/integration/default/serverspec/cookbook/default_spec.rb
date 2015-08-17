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

# this is a generic ServerSpec test.  It just runs 'whoami'
# and confirms that it returns 'root'.  In a real test suite,
# you would want to test things like directories, users,
# processes, services, etc.
#
# for more information on the things ServerSpec can test, refer
# to the documentation at http://serverspec.org
describe command('whoami') do
  its(:stdout) { should eq "root\n" }
end
