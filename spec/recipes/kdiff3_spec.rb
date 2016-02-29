RSpec.describe 'chefdk_bootstrap::kdiff3' do
  include_context 'windows_2012'

  it 'installs the kdiff3 visual diff tool' do
    pending('Waiting on chocolatey_package matchers in ChefSpec 4.6')
    expect(windows_chef_run).to install_chocolatey_package('kdiff3')
  end
end
