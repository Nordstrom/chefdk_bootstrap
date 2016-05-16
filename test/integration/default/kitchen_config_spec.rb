describe file('C:/Users/Vagrant/.kitchen/config.yml') do
  if ENV['http_proxy']
    it { should exist }
    its('content') { should match(/<%/) }
  else
    it { should_not exist }
  end
end
