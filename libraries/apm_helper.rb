#
# Cookbook Name:: atom
# Library:: apm
#
# Author:: Mohit Sethi <mohit@sethis.in>
#          Mark Gibbons
#
# Copyright 2013-2014, Mohit Sethi.
# Copyright 2018 Nordstrom, Inc
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

# atom package management helpers
module AtomApmHelper
  require 'chef/mixin/shell_out'
  require_relative 'os'
  include Chef::Mixin::ShellOut
  include OS

  def disabled?(package)
    disabled = shell_out("#{apm} list").stdout
    disabled =~ /^.*\s#{package}@.*disabled/ ? true : false
  end

  def enabled?(package)
    installed?(package) && !disabled?(package)
  end

  def installed?(package)
    installed = shell_out("#{apm} list").stdout
    installed =~ /^.*\s#{package}(@|$)/ ? true : false
  end

  def upgrade_available?(package)
    updates = shell_out("#{apm} upgrade -l #{package_name(package)}").stdout
    updates =~ /Available\s+\(0\)/ ? false : true
  end

  def package_name(package)
    # remove any version information
    package.sub(/@.*/, '')
  end

  def apm
    OS.windows? ? '%localappdata%/atom/bin/apm' : 'apm'
  end
end
