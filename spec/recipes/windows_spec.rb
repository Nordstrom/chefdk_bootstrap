RSpec.describe 'chefdk_bootstrap::windows' do
  context 'default attributes' do
    cached(:windows_node) do
      ChefSpec::ServerRunner.new(
        platform: 'windows',
        version: '2012R2'
      ).converge(described_recipe)
    end

    it 'includes the chocolatey recipe' do
      expect(windows_node).to include_recipe('chocolatey')
    end

    it 'includes atom recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::atom')
    end

    it 'includes virtualbox recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::virtualbox')
    end

    it 'includes vagrant recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::vagrant')
    end

    it 'includes git recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::git')
    end

    it 'includes kdiff3 recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::kdiff3')
    end

    it 'includes gitextensions recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::gitextensions')
    end
  end

  context 'with attribute overrides' do
    cached(:windows_node) do
      ChefSpec::ServerRunner.new(
        platform: 'windows',
        version: '2012R2'
      ) do |node|
        node.set['chefdk_bootstrap']['package']['atom'] = false
        node.set['chefdk_bootstrap']['package']['gitextensions'] = false
      end.converge(described_recipe)
    end

    it 'does not include atom recipe' do
      expect(windows_node).to_not include_recipe('chefdk_bootstrap::atom')
    end

    it 'does not include gitextensions recipe' do
      expect(windows_node).to_not include_recipe('chefdk_bootstrap::gitextensions')
    end

    it 'includes virtualbox recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::virtualbox')
    end

    it 'includes kdiff3 recipe' do
      expect(windows_node).to include_recipe('chefdk_bootstrap::kdiff3')
    end
  end
end
