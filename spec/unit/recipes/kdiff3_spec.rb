RSpec.describe 'chefdk_bootstrap::kdiff3', win_bootstrap: true do
  include_context 'windows_2012'

  it 'installs the kdiff3 visual diff tool' do
    expect(windows_chef_run).to install_chocolatey_package('kdiff3')
  end
end
