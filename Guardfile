notification :terminal_title

# prevent dropping into pry when nothing is happening
interactor :off

# automatically runs Foodcritic
guard :foodcritic, cookbook_paths: '.', cli: '-f any -X spec -X test -X features' do
  watch(%r{^attributes/.+\.rb$})
  watch(%r{^resources/.+\.rb$})
  watch(%r{^providers/.+\.rb$})
  watch(%r{^libraries/.+\.rb$})
  watch(%r{^recipes/.+\.rb$})
  watch(%r{^metadata\.rb$})
end

# automatically runs Tailor
guard :rake, all_on_start: true, task: :tailor do
  watch(%r{^spec/recipes/.+_spec\.rb$})
  watch(%r{^spec/spec_helper\.rb$})
  watch(%r{^attributes/.+\.rb$})
  watch(%r{^resources/.+\.rb$})
  watch(%r{^providers/.+\.rb$})
  watch(%r{^libraries/.+\.rb$})
  watch(%r{^recipes/.+\.rb$})
  watch(%r{^metadata\.rb$})
end

# automatically runs Rubocop
guard :rubocop, all_on_start: true, cli: ['-f', 'p', '-D'] do
  watch(%r{^attributes/.+\.rb$})
  watch(%r{^recipes/.+\.rb$})
  watch(%r{^libraries/.+\.rb$})
  watch(%r{^resources/.+\.rb$})
  watch(%r{^providers/.+\.rb$})
  watch(%r{^spec/.+\.rb$})
  watch(%r{^test/.+\.rb$})
  watch(%r{^metadata\.rb$})
  watch(%r{^Berksfile$})
  watch(%r{^Gemfile$})
  watch(%r{^Rakefile$})
end

# automatically runs ChefSpec tests
rspec_command = ENV.key?('DISABLE_PRY_RESCUE') ? 'rspec' : 'rescue rspec'
guard :rspec, all_on_start: true, cmd: "bundle exec #{rspec_command}" do
  watch(%r{^spec/recipes/.+_spec\.rb$})
  watch(%r{^spec/spec_helper\.rb$}) { 'spec' }
  watch(%r{^attributes/.+\.rb$})    { 'spec' }
  watch(%r{^resources/.+\.rb$})     { 'spec' }
  watch(%r{^providers/.+\.rb$})     { 'spec' }
  watch(%r{^libraries/.+\.rb$})     { 'spec' }
  watch(%r{^recipes/(.+)\.rb$})     { |m| "spec/recipes/#{m[1]}_spec.rb" }
end

# load local overrides
guardfile_dir = File.absolute_path(File.join('.', 'lib', 'guardfile'))
Dir.glob(File.join(guardfile_dir, '*.guard')).each do |snippet|
  eval File.read(snippet), nil, snippet # rubocop:disable Lint/Eval
end
