RSpec.describe 'chefdk_bootstrap::virtualbox' do
  context 'On a Windows machine' do
    include_context 'windows_2012'

    it 'installs Virtualbox via Chocolatey' do
      pending('Waiting on chocolatey_package matchers in ChefSpec 4.6')
      expect(windows_chef_run).to install_chocolatey_package('virtualbox')
    end
  end

  context 'On a Mac' do
    include_context 'mac_os_x'

    it 'installs Virtualbox via homebrew_cask' do
      expect(mac_os_x_chef_run).to install_homebrew_cask('virtualbox')
    end
  end
end
