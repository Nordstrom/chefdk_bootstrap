# add powershell_out to powershell_script
Chef::Resource::PowershellScript.send(:include, Chef::Mixin::PowershellOut)

# get the real path to the powershell profiles.  Note that sysnative is a virtual alias
# that lets a 32-bit app reference the 64-bit system dir which is called system32 (srsly?)
# http://support2.microsoft.com/kb/942589
profiledir = File.join(ENV['SystemRoot'], 'SysNative', 'WindowsPowerShell', 'v1.0')
real_profiledir = File.join(ENV['SystemRoot'], 'System32', 'WindowsPowerShell', 'v1.0')

# create the PowerShell snippet
template ::File.join(profiledir, 'chefdk.ps1') do
  source 'chefdk_profile.ps1.erb'
end

# only change PowerShell execution policy and global profile if not suppressed via attributes
if node['chefdk_bootstrap']['powershell']['configure']
  # set the PowerShell Execution Policy to RemoteSigned
  powershell_script 'set execution policy to RemoteSigned' do
    code 'Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force'
    only_if { powershell_out('Get-ExecutionPolicy -Scope LocalMachine | Select-String RemoteSigned').stdout.empty? }
  end

  # create the global PowerShell profile to include the snippet (if it does not already exist)
  template ::File.join(profiledir, 'profile.ps1') do
    action :create_if_missing
    source 'global_profile.ps1.erb'
    variables(profiledir: real_profiledir)
  end
end
