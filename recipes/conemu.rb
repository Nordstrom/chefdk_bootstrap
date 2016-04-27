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

chocolatey_package 'conemu' do
  # If conemu was installed outside chocolatey, it could be running this
  # installation script and we don't want to touch it
  not_if '(& "C:\Program Files\ConEmu\ConEmu\ConEmuC.exe" /IsConEmu); $LASTEXITCODE -eq 1'
  guard_interpreter :powershell_script
end
