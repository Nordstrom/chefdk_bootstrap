RSpec.describe 'chefdk_bootstrap::gitextensions' do
  include_context 'windows_2012'

  it 'installs GitExtensions via Chocolatey' do
    skip('Waiting on chocolatey_package matchers in ChefSpec 4.6')
    expect(windows_chef_run).to install_chocolatey_package('gitextensions')
  end
end
