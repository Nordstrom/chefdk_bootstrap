describe command('atom -v') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }
end
