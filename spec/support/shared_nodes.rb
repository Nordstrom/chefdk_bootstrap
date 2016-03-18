
RSpec.shared_context 'windows_2012' do
  cached(:windows_chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'windows',
      version: '2012R2',
      file_cache_path: 'c:/chef/cache/'
    ) do |node|
      node.set['vagrant']['checksum'] = 'abc123'
    end.converge(described_recipe)
  end
end

RSpec.shared_context 'mac_os_x' do
  cached(:mac_os_x_chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'mac_os_x',
      version: '10.10',
      file_cache_path: '/var/chef/cache/'
    ) do |node|
      node.set['vagrant']['checksum'] = 'abc123'
    end.converge(described_recipe)
  end

  before(:example) do
    # this stub is needed for homebrew specs
    stub_command('which git').and_return('/usr/local/bin/git')
  end
end
