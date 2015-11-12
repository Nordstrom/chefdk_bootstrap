RSpec.describe 'chefdk_bootstrap::vagrant' do
  context 'on a Windows 2012R2 node' do
    cached(:windows_chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'windows',
        version: '2012R2'
      ).converge(described_recipe)
    end

    it 'installs Vagrant via Chocolatey' do
      expect(windows_chef_run).to install_chocolatey('vagrant')
    end
  end

  context 'on a Mac' do
    cached(:mac_os_x_chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'mac_os_x',
        version: '10.10'
      ).converge(described_recipe)
    end

    it 'installs Vagrant via homebrew_cask' do
      expect(mac_os_x_chef_run).to install_homebrew_cask('vagrant')
    end
  end
end
