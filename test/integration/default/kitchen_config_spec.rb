username = ENV['APPVEYOR'] ? ENV['username'] : 'vagrant'

describe file("C:/Users/#{username}/.kitchen/config.yml") do
  if ENV['http_proxy']
    it { should exist }
    its('content') { should match(/<%/) }
  else
    it { should_not exist }
  end
end
