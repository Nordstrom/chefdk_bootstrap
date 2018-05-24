# Cookbook Name:: chefdk_bootstrap
# Rakefile

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

require 'cookstyle'
require 'rubocop/rake_task'
require 'foodcritic'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new do |rubocop|
  rubocop.options << '--display-cop-names'
end

FoodCritic::Rake::LintTask.new

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--tag ~mac_bootstrap' if Gem.win_platform?
  t.rspec_opts = '--tag ~win_bootstrap' unless Gem.win_platform?
end

desc 'Run Rubocop and Foodcritic style checks'
task style: %i(rubocop foodcritic)

desc 'Run all style checks and unit tests'
task test: %i(style spec)

task default: :test

desc 'Generate ChefSpec coverage report'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task[:spec].invoke
end

begin
  require 'stove/rake_task'
  Stove::RakeTask.new
rescue LoadError
  puts '>>>>> Stove gem not installed' unless ENV['CI']
end

# don't require kitchen rake tasks in Travis-CI
unless ENV['CI']
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
end
