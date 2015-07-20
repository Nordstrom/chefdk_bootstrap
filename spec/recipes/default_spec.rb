RSpec.describe 'chefdk_bootstrap::default' do
  context 'On a Windows machine' do
    let(:windows_node) do
      ChefSpec::ServerRunner.new(
        platform: 'windows',
        version: '2012R2'
      )
    end

    before do
      windows_node.converge(described_recipe)
    end

    it 'converges successfully' do
      expect(windows_node).to include_recipe(described_recipe)
    end

    it 'includes the platform specific entry point recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::windows')
    end
  end

  context 'On a Mac OS X machine' do
    let(:mac_os_x_node) do
      ChefSpec::ServerRunner.new(
        platform: 'mac_os_x',
        version: '10.10'
      )
    end

    before do
      stub_command('which git')
      mac_os_x_node.converge(described_recipe)
    end

    it 'converges successfully' do
      expect(mac_os_x_node).to include_recipe(described_recipe)
    end

    it 'includes the platform specific entry point recipe' do
      expect(mac_os_x_node).to include_recipe('chefdk_bootstrap::mac_os_x')
    end
  end
end
