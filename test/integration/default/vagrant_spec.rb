describe command('vagrant -v') do
  its(:exit_status) { should eq(0) }
  its(:stdout) { should match(/Vagrant \d+\.\d+\.\d+/) }
end
