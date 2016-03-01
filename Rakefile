# Copyright 2015 Nordstrom, Inc.
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

require 'foodcritic'
require 'foodcritic/rake_task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

# Style tests (Foodcritic)
FoodCritic::Rake::LintTask.new

RuboCop::RakeTask.new do |t|
  t.formatters = ['progress']
  t.options = ['-D']
  t.patterns = %w(
    attributes/*.rb
    recipes/*.rb
    libraries/**/*.rb
    resources/*.rb
    providers/*.rb
    spec/**/*.rb
    test/**/*.rb
    ./metadata.rb
    ./Berksfile
    ./Rakefile
  )
end

desc 'Run Style Tests'
task style: [:foodcritic, :rubocop]

# ChefSpec (RSpec)
RSpec::Core::RakeTask.new

task default: [:style, :spec]

desc 'Generate ChefSpec coverage report'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task[:spec].invoke
end

# Test Kitchen
begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  warn 'test-kitchen initialization failed; disabling kitchen tasks'
end

# if we are running inside the CI pipeline, turn on
# xUnit-style test reports
if ENV.key?('CI_BUILD')
  require 'ci/reporter/rake/rspec'
  task spec: 'ci:setup:rspec'
end
