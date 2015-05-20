RSpec.describe 'chefdk_bootstrap::default' do
  context 'On a Windows machine' do
    let(:windows_node) do
      ChefSpec::ServerRunner.new(
        platform: 'windows',
        version: '2012R2'
      )
    end

    it 'converges successfully' do
      windows_node.converge(described_recipe)
      expect(windows_node).to include_recipe(described_recipe)
    end
  end
end
