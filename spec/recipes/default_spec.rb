RSpec.describe 'chefdk_bootstrap::default' do
  let(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

  it 'converges successfully' do
    expect(chef_run).to include_recipe(described_recipe)
  end
end
