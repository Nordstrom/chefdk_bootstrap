#
# Copyright 2016 Nordstrom, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require_relative '../../bootstrap'

RSpec.describe ChefDKBootstrap::Cli, mac_bootstrap: true do
  subject(:cli) { described_class.new(arguments) }

  describe '#parse' do
    context 'no options' do
      let(:arguments) { [] }

      it 'nothing is returned in the options hash' do
        options = {}
        expect(cli.parse).to eq(options)
      end
    end

    context 'long options' do
      let(:arguments) do
        %w(--json-attributes http://server/attributes.json --version 0.14.25)
      end

      it 'all long options specified' do
        options = {
          json_attributes: 'http://server/attributes.json',
          version: '0.14.25',
        }
        expect(cli.parse).to eq(options)
      end
    end

    context 'short options' do
      let(:arguments) { %w(-j http://server/attributes.json -v 0.14.25) }

      it 'all short options specified' do
        options =
          {
            json_attributes: 'http://server/attributes.json',
            version: '0.14.25',
          }
        expect(cli.parse).to eq(options)
      end
    end
  end
end

RSpec.describe ChefDKBootstrap::Berksfile, mac_bootstrap: true do
  subject(:berksfile) { described_class.new(options) }

  describe '#create' do
    let(:options) { {} }
    cookbook_version = File.read('metadata.rb').match(/^version[\s']+(\d+\.\d+\.\d+)/)[1]

    it 'creates berksfile with default values' do
      berksfile.create
      expect(File.read(berksfile.path))
        .to include("cookbook 'chefdk_bootstrap', '#{cookbook_version}'")
        .and include("source 'https://supermarket.chef.io'")
    end
  end

  describe '#delete' do
    let(:options) { { cookbook: 'chefdk_bootstrap' } }

    it 'deletes berksfile' do
      berksfile.create
      berksfile.delete
      expect(File.exist?(berksfile.path)).to eq(false)
    end
  end
end

RSpec.describe ChefDKBootstrap::ClientRb, mac_bootstrap: true do
  subject(:clientrb) { described_class.new }

  describe '#create' do
    it 'creates client.rb file' do
      clientrb.create
      expect(File.read(clientrb.path))
        .to eq("cookbook_path '#{File.join(Dir.pwd, 'berks-cookbooks')}'\n")
    end
  end

  describe '#delete' do
    it 'deletes client.rb' do
      clientrb.create
      clientrb.delete
      expect(File.exist?(clientrb.path)).to eq(false)
    end
  end
end

RSpec.describe ChefDKBootstrap::ChefDK, mac_bootstrap: true do
  subject(:chefdk) { described_class.new(options) }

  describe '#installed_version' do
    let(:options) { {} }

    it 'determines the currently installed version' do
      cmd_response = <<-EOH.gsub(/^\s+/, '')
        Chef Development Kit Version: 0.14.25
        chef-client version: 12.10.24
        berks version: 4.3.3
        kitchen version: 1.8.0
        EOH
      allow(chefdk).to receive(:installed_info).and_return(cmd_response)
      expect(chefdk.installed_version).to eq('0.14.25')
    end

    it 'determines chefdk is not currently installed' do
      allow(chefdk).to receive(:installed_info).and_return('')
      expect(chefdk.installed_version).to be_nil
    end
  end

  describe '#latest_version' do
    let(:options) { {} }

    it 'determines the latest available version' do
      metadata_response = <<-EOH.gsub(/^\s+/, '')
      sha1	c5abf2f5b916204b02f9307c91bfc3b272e99684
      sha256	44adc9519697a468e2cf12322facf1f766dc832b60c58029696a88c135a3b58e
      url	https://packages.chef.io/stable/mac_os_x/10.11/chefdk-0.15.15-1.dmg
      version	0.15.15
      EOH
      allow(chefdk).to receive(:latest_info).and_return(metadata_response)
      expect(chefdk.latest_version).to eq('0.15.15')
    end
  end

  describe '#target_version_installed?' do
    context 'version is not specified' do
      let(:options) { {} }

      it 'returns true if latest version is installed and no target is set' do
        allow(chefdk).to receive(:installed_version).and_return('0.15.15')
        allow(chefdk).to receive(:latest_version).and_return('0.15.15')
        expect(chefdk.target_version_installed?).to be true
      end

      it 'returns false if chefdk is not installed yet' do
        allow(chefdk).to receive(:installed_version).and_return(nil)
        allow(chefdk).to receive(:latest_version).and_return('0.15.15')
        expect(chefdk.target_version_installed?).to be false
      end

      it 'returns false if latest version is not installed and no target is set' do
        allow(chefdk).to receive(:installed_version).and_return('0.14.25')
        allow(chefdk).to receive(:latest_version).and_return('0.15.15')
        expect(chefdk.target_version_installed?).to be false
      end
    end

    context 'version is specified' do
      let(:options) { { version: '0.14.25' } }

      it 'returns true if target_version is installed' do
        allow(chefdk).to receive(:installed_version).and_return('0.14.25')
        allow(chefdk).to receive(:latest_version).and_return('0.15.15')
        expect(chefdk.target_version_installed?).to be true
      end
    end

    context 'older version is specified' do
      let(:options) { { version: '0.14.25' } }

      it 'returns false if target version is not the installed version' do
        allow(chefdk).to receive(:installed_version).and_return('0.15.15')
        allow(chefdk).to receive(:latest_version).and_return('0.15.15')
        expect(chefdk.target_version_installed?).to be false
      end
    end
  end
end
