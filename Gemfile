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

source 'https://rubygems.org'

group :development do
  # pin to 2.8 series until guard-foodcritic has been updated for v2 API
  gem 'guard', '~> 2.8.2'
  # pin to 4.3 series until guard-foodcritic has been updated for v2 API
  gem 'guard-rspec', '~> 4.3.1'
  gem 'guard-foodcritic', '~> 1.0'
  gem 'guard-rake', '~> 0.0'
  gem 'guard-rubocop', '~> 1.1'
  gem 'ruby_gntp', '~> 0.3'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rescue', '~> 1.3'
  gem 'pry-stack_explorer', '~> 0.4'
end

group :integration do
  gem 'test-kitchen', '~> 1.4'
  gem 'kitchen-vagrant', '~> 0.17'
  gem 'winrm-transport', '~> 1.0'
end

group :test do
  gem 'rake', '~> 10.3'
  gem 'foodcritic', '~> 4.0'
  gem 'chefspec', '~> 4.2'
  gem 'ci_reporter_rspec', '~> 1.0'
  gem 'berkshelf', '~> 3.3'
  gem 'berkshelf-api-client', '~> 1.3'
  gem 'rubocop', '~> 0.33'
end

# load local overrides
gemfile_dir = File.absolute_path(File.join('.', 'lib', 'gemfile'))
Dir.glob(File.join(gemfile_dir, '*.bundler')).each do |snippet|
  # rubocop:disable Lint/Eval
  eval File.read(snippet), nil, snippet
end
