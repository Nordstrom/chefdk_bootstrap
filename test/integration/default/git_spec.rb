describe command('git --version') do
  # git version 2.8.1.windows.1
  its(:stdout) { should match(/git version \d+\.\d+\.\d+/) }
end

describe command('git config --get credential.helper') do
  # verify git-credential-manager-for-windows is configured correctly
  its(:stdout) { should match(/manager/) }
end

git_credential_mgr = File.join(
  '$env:LOCALAPPDATA',
  'Programs\Microsoft Git Credential Manager for Windows',
  'git-credential-manager.exe'
)

describe command("& \"#{git_credential_mgr}\" version") do
  its(:exit_status) { should eq(0) }
  its(:stderr) { should eq '' }
end

# PoshGit
describe powershell('test-path Function:\PoshGitPrompt') do
  its(:stdout) { should match(/^True\R/) }
end
