RSpec.shared_context 'mock_chocolatey_installed' do
  before(:example) do
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        @vpd_setting = mocks.verify_partial_doubles?
        mocks.verify_partial_doubles = false
      end
    end

    allow_any_instance_of(Chef::Resource::RemoteFile).to receive(
      :chocolatey_installed?).and_return(true)
  end

  after do
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        mocks.verify_partial_doubles = @vpd_setting
      end
    end
  end
end
