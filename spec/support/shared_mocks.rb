RSpec.shared_context 'windows_mocks' do
  before(:example) do
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        @vpd_setting = mocks.verify_partial_doubles?
        mocks.verify_partial_doubles = false
      end
    end

    allow_any_instance_of(Chef::Resource::Template).to receive(
      :chocolatey_installed?).and_return(true)

    allow_any_instance_of(Chef::Recipe)
      .to receive(:locate_sysnative_cmd)
      .with('WindowsPowerShell\v1.0')
      .and_return('C:\WINDOWS\sysnative\WindowsPowerShell\v1.0')
  end

  after do
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        mocks.verify_partial_doubles = @vpd_setting
      end
    end
  end
end
