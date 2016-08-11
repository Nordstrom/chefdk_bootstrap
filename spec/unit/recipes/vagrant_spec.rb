RSpec.describe 'chefdk_bootstrap::vagrant' do
  context 'on a Windows 2012R2 node', win_bootstrap: true do
    include_context 'windows_2012'

    it 'includes the vagrant::default recipe' do
      expect(windows_chef_run).to include_recipe('vagrant')
    end
  end

  context 'on a Mac' do
    include_context 'mac_os_x'

    it 'includes the vagrant::default recipe' do
      expect(mac_os_x_chef_run).to include_recipe('vagrant')
    end
  end
end
