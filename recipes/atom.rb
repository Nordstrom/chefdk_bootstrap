atom_setup = File.join(Chef::Config[:file_cache_path], 'AtomSetup.exe')

remote_file atom_setup do
  source node['chefdk_bootstrap']['atom']['source_url']
  backup false
end

windows_package 'Atom' do
  source atom_setup
end
