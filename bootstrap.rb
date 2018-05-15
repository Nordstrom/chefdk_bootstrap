#! /usr/bin/env ruby
#
# Copyright 2016, 2018 Nordstrom, Inc.
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
require 'optparse'
require 'tmpdir'

module ChefDKBootstrap
  # Class to parse command line options.
  #
  # @!attribute [r] path
  #  @return [String] path of berksfile
  class Cli
    # Initializes Cli object.
    #
    # @param [Array] command line arguments, typically ARGV
    def initialize(argv)
      @argv = argv
    end

    # Parses the command line options
    #
    # @return [Hash] parsed command line options
    #  * :cookbook [String] custom ChefDK_bootstrap wrapper cookbook name
    #  * :berks_source [String] private supermarket URL
    #  * :json_attributes [String] URL/path to the JSON file
    def parse
      options = {}

      option_parser = OptionParser.new do |opts|
        executable_name = File.basename($PROGRAM_NAME)
        opts.banner = "Usage: #{executable_name} [options]"

        opts.on('-j', '--json-attributes JSON_ATTRIBUTES', 'Enter your URL/path to the JSON file containing your JSON attributes.') do |v|
          options[:json_attributes] = v
        end

        opts.on('-v', '--version VERSION', 'Enter the version of ChefDK to install.') do |v|
          options[:version] = v
        end

        opts.on('-c', '--cookbook Cookbook', 'Enter the name of a wrapper cookbook for chefdk_bootstrap.') do |_v|
          options[:cookbook] = c
        end
      end

      option_parser.parse!(@argv)
      options
    end
  end
  # rubocop:enable MethodLength

  # Class to create and delete Berksfile.
  #
  # @!attribute [r] path
  #  @return [String] path of berksfile
  class Berksfile
    attr_reader :path

    # Initializes Berksfile object.
    #
    # @param [Hash] parsed command line options
    #  * :cookbook [String] custom ChefDK_bootstrap wrapper cookbook name
    #  * :berks_source [String] private supermarket URL
    #  * :json_attributes [String] URL/path to the JSON file
    def initialize(options)
      @cookbook = options[:cookbook] ? "'#{options[:cookbook]}'" : "'chefdk_bootstrap', '2.4.1'#{ENV['CHEFDK_BOOT_LOCAL']}"
    end

    # Creates berksfile in a temp directory
    #
    # @return [File] berksfile object
    def create
      @tempdir = Dir.mktmpdir('chefdk_bootstrap-')

      berksfile_content = <<-EOH.gsub(/^\s+/, '')
        source 'https://supermarket.chef.io'

        cookbook #{@cookbook}
        EOH
      @path = File.join(@tempdir, 'Berksfile')
      File.open(path, 'w') { |b| b.write(berksfile_content) }
    end

    # Deletes the temp directory & its contents
    def delete
      FileUtils.remove_dir(@tempdir, true)
    end

    # berks vendor
    def download_dependencies
      puts 'Downloading cookbook dependencies with Berkshelf'
      Dir.chdir(@tempdir)
      raise "Berks vendor to #{@tempdir} failed" unless system('chef exec berks vendor')
    end
  end

  # Class to create and delete client.rb
  #
  # @!attribute [r] path
  #  @return [String] path of client.rb file
  class ClientRb
    attr_reader :path

    # Creates client.rb in a temp directory
    #
    # @return [File] client.rb object
    def create
      @tempdir = Dir.mktmpdir('chefdk_bootstrap-')

      clientrb_content = <<-EOH.gsub(/^\s+/, '')
        cookbook_path '#{File.join(Dir.pwd, 'berks-cookbooks')}'
        ohai.disabled_plugins = [ :Passwd ]
        EOH
      @path = File.join(@tempdir, 'client.rb')
      File.open(@path, 'w') { |c| c.write(clientrb_content) }
    end

    # Deletes the temp directory & its contents
    def delete
      FileUtils.remove_dir(@tempdir, true)
    end
  end

  # Install chefdk
  class ChefDK
    CHEFDK_VERSION_PATTERN = /Chef Development Kit Version: (?<version>\d{1,2}\.\d{1,2}\.\d{1,2})/i
    CHEFDK_LATEST_PATTERN = /version\s(?<version>\d{1,2}\.\d{1,2}\.\d{1,2})/i

    def initialize(options)
      @target_version = options[:version]
    end

    # Shell command to determine if chef is currently installed
    #
    # @return [string] chefdk version information or empty string if not installed
    def installed_info
      `chef -v 2>/dev/null`
    end

    # Gets chefdk version currently installed or nil if not installed
    #
    # @return [string] chefdk installed version or nil if not installed
    def installed_version
      installed_info.empty? ? nil : installed_info.match(CHEFDK_VERSION_PATTERN)[:version]
    end

    # Shell command to determine lastest version of chefdk
    #
    # @return [String] latest stable chefdk version (assuming latest version is samme for all OS)
    def latest_info
      `curl --silent --show-error 'https://omnitruck.chef.io/stable/chefdk/metadata?p=mac_os_x&pv=10.11&m=x86_64&v=latest'`
    end

    # Gets chefdk latest version available
    def latest_version
      latest_info.match(CHEFDK_LATEST_PATTERN)[:version]
    end

    def target_version
      @target_version || latest_version
    end

    # Installs chefdk
    def install
      puts 'Installing ChefDK'
      install_command = "curl --silent --show-error https://omnitruck.chef.io/install.sh | \
              sudo -E bash -s -- -c stable -P chefdk"
      install_command << " -v #{target_version}" if target_version
      raise 'ChefDK install failed' unless system(install_command)
    end

    # Determine if the target version is already installed
    #
    # @return [Boolean] true if target version is installed, else false
    def target_version_installed?
      target_version == installed_version
    end
  end

  # Run chef-client
  class ChefClient
    # Initializes ChefClient object with a client.rb file.
    #
    # @param [Hash] parsed command line options
    #  * :cookbook [String] custom ChefDK_bootstrap wrapper cookbook name
    #  * :berks_source [String] private supermarket URL
    #  * :json_attributes [String] URL/path to the JSON file
    def initialize(options, client_rb = ClientRb.new)
      @client_rb = client_rb
      @client_rb.create
      @cookbook = options[:cookbook] || 'chefdk_bootstrap'
      @json_attributes = options[:json_attributes].nil? ? nil : " --json-attributes #{options[:json_attributes]}"
    end

    # Runs the chef-client with specified cookbook and json attributes
    def run
      raise 'Chef-client failed' unless system("sudo -E chef-client -z -l error -c #{@client_rb.path} -o '#{@cookbook}' #{@json_attributes}")
    end
  end
end

# Wrapping bootstrap script to allow for unit testing
if $PROGRAM_NAME == __FILE__
  include ChefDKBootstrap
  options = Cli.new(ARGV).parse
  berksfile = Berksfile.new(options)
  berksfile.create
  client_rb = ClientRb.new
  client_rb.create

  chefdk = ChefDK.new(options)
  chefdk.install unless chefdk.target_version_installed?

  berksfile.download_dependencies
  chefclient = ChefClient.new(options, client_rb)
  chefclient.run

  berksfile.delete
  client_rb.delete
end
