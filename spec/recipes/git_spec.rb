RSpec.describe 'chefdk_bootstrap::git' do
  context 'On a Windows machine', focus: true do
    cached(:windows_node) do
      ChefSpec::SoloRunner.new(
        platform: 'windows',
        version: '2012R2'
      ).converge(described_recipe)
    end

    it 'installs the correct version of Git' do
      expect(windows_node).to install_chocolatey('git')
    end

    it 'installs the Git credential helper' do
      expect(windows_node).to install_chocolatey('git-credential-manager-for-windows')
    end

    it 'installs poshgit' do
      expect(windows_node).to install_chocolatey('poshgit')
    end
  end
end
