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

# Your test-kitchen box may not have your corporate proxy settings.
# This is how to fix that for our test-kitchen converges.

autoconfig_url = node['chefdk_bootstrap-test']['proxy']['automatic_proxy_script_url']
http_proxy = node['chefdk_bootstrap-test']['proxy']['http_proxy']
proxy_override = node['chefdk_bootstrap-test']['proxy']['no_proxy']

registry_key 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings' do
  values [{ name: 'AutoConfigURL', type: :string, data: autoconfig_url }]
  not_if { autoconfig_url.nil? }
end

registry_key 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings' do
  values [{ name: 'ProxyServer', type: :string, data: http_proxy }]
  not_if { http_proxy.nil? }
end

registry_key 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings' do
  values [{ name: 'ProxyOverride', type: :string, data: proxy_override }]
  not_if { proxy_override.nil? }
end
