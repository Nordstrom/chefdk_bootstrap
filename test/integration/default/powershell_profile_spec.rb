# PowerShell profile
describe file('C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1') do
  its('content') { should match(/chef shell-init powershell/) }
end
