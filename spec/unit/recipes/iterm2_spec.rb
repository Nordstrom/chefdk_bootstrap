RSpec.describe 'chefdk_bootstrap::iterm2' do
  include_context 'mac_os_x'

  it 'installs iterm2 via homebrew_cask' do
    expect(mac_os_x_chef_run).to install_homebrew_cask('iterm2')
  end
end
