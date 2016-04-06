describe command('& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --version') do
  its(:exit_status) { should eq(0) }
  its(:stderr) { should eq '' }
end
