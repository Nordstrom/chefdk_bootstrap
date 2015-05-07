
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
