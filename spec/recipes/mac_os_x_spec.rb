RSpec.describe 'chefdk_bootstrap::mac_os_x' do
  let(:mac_os_x_node) do
    ChefSpec::ServerRunner.new(
      platform: 'mac_os_x',
      version: '10.10'
    )
  end

  before do
    stub_command('which git')
  end

  it 'creates /usr/local and sets the owner to SUDO_USER when specified' do
    # use call original as per http://www.relishapp.com/rspec/rspec-mocks/v/3-3/docs/configuring-responses/calling-the-original-implementation#%60and-call-original%60-can-configure-a-default-response-that-can-be-overriden-for-specific-args
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('SUDO_USER').and_return('serena')
    mac_os_x_node.converge(described_recipe)
    expect(mac_os_x_node).to create_directory('/usr/local').with(
      owner: 'serena'
    )
  end

  it 'creates /usr/local and sets the owner to USER when SUDO_USER is not specified' do
    # use call original as per http://www.relishapp.com/rspec/rspec-mocks/v/3-3/docs/configuring-responses/calling-the-original-implementation#%60and-call-original%60-can-configure-a-default-response-that-can-be-overriden-for-specific-args
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('SUDO_USER').and_return(nil)
    allow(ENV).to receive(:[]).with('USER').and_return('doug')
    mac_os_x_node.converge(described_recipe)
    expect(mac_os_x_node).to create_directory('/usr/local').with(
      owner: 'doug'
    )
  end

  context 'foo' do
    before do
      mac_os_x_node.converge(described_recipe)
    end

    recipes = %w(
      homebrew
      homebrew::cask
      chefdk_bootstrap::virtualbox
      chefdk_bootstrap::vagrant
      chefdk_bootstrap::atom
      chefdk_bootstrap::git
      chefdk_bootstrap::iterm2
    )

    recipes.each do |recipe|
      it "includes the #{recipe} recipe" do
        expect(mac_os_x_node).to include_recipe(recipe)
      end
    end
  end
end
