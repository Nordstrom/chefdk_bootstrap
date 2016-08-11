RSpec.describe 'chefdk_bootstrap::git' do
  context 'On a Windows machine', win_bootstrap: true do
    include_context 'windows_2012'

    it 'installs the correct version of Git' do
      expect(windows_chef_run).to install_chocolatey_package('git')
    end

    it 'installs the Git credential helper' do
      expect(windows_chef_run).to install_chocolatey_package('git-credential-manager-for-windows')
    end

    # it 'installs poshgit' do
    #   expect(windows_chef_run).to install_chocolatey_package('poshgit')
    # end
  end

  context 'On a Mac' do
    include_context 'mac_os_x'

    it 'installs the latest git package' do
      expect(mac_os_x_chef_run).to install_package('git')
    end
  end
end
