RSpec.describe 'chefdk_bootstrap::virtualbox' do
  context 'On a Windows machine', win_bootstrap: true do
    include_context 'windows_2012'

    it 'installs Virtualbox via Chocolatey' do
      expect(windows_chef_run).to install_chocolatey_package('virtualbox')
    end
  end

  context 'On a Mac' do
    include_context 'mac_os_x'

    it 'downloads and installs Virtualbox' do
      expect(mac_os_x_chef_run).to install_dmg_package('Virtualbox').with(
        source: 'http://download.virtualbox.org/virtualbox/5.0.14/VirtualBox-5.0.14-105127-OSX.dmg',
        checksum: '4de41068712eb819749b5376c90dca47f9a1d6eecf4c516d83269ac12add2aa4',
        type: 'pkg'
      )
    end
  end
end
