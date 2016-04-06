%w(chef .chef chef\cookbooks).each do |dir|
  describe directory(dir) do
    it { should be_directory }
  end
end
