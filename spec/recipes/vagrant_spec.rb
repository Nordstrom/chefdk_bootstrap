RSpec.describe 'chefdk_bootstrap::vagrant', focus: true do
  context 'on a Windows 2012R2 node' do
    cached(:windows_chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'windows',
        version: '2012R2'
      ) do |node|
        node.set['vagrant']['checksum'] = 'abc123'
      end.converge(described_recipe)
    end

    it 'includes the vagrant::default recipe' do
      expect(windows_chef_run).to include_recipe('vagrant')
    end
  end

  context 'on a Mac' do
    cached(:mac_os_x_chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'mac_os_x',
        version: '10.10'
      ) do |node|
        node.set['vagrant']['checksum'] = 'abc123'
      end.converge(described_recipe)
    end

    it 'includes the vagrant::default recipe' do
      expect(mac_os_x_chef_run).to include_recipe('vagrant')
    end
  end
end
