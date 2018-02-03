# Cookbook Name: chefdk_bootstrap
# Library: helpers

# Author:: Mark Gibbons
# Copyright:: Copyright (c) 2018 Nordstrom, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Monkey patch the vagrant helper methods to find the mac vagrant packages
# Work around an upstream error caused by a change in the vagrant package name scheme
# See pull request https://github.com/jtimberman/vagrant-cookbook/pull/79

module Vagrant
  module Helpers
    def package_extension
      extension = value_for_platform_family(
        'mac_os_x' =>  mac_os_x_extension,
        'windows' => '.msi',
        'debian' => '_x86_64.deb',
        %w(rhel suse fedora) => '_x86_64.rpm'
      )
      raise ArgumentError "HashiCorp doesn't provide a Vagrant package for the #{node['platform']} platform." if extension.nil?

      extension
    end

    def mac_os_x_extension
      last_using_dmg = Gem::Version.new('1.9.2')
      Gem::Version.new(package_version) > last_using_dmg ? '_x86_64.dmg' : '.dmg'
    end
  end
end
