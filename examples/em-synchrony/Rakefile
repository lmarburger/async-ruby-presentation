require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs    << 'spec'
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = true
end

task :default => :test
