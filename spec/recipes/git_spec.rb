RSpec.describe 'chefdk_bootstrap::git' do
  context 'On a Windows machine' do
    include_context 'windows_2012'

    it 'installs the correct version of Git' do
      expect(windows_chef_run).to install_chocolatey('git')
    end

    it 'installs the Git credential helper' do
      expect(windows_chef_run).to install_chocolatey('git-credential-manager-for-windows')
    end

    it 'installs poshgit' do
      expect(windows_chef_run).to install_chocolatey('poshgit')
    end
  end
end
