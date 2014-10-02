require 'rake/testtask'

Rake::TestTask.new do |t|
	require 'simplecov'
	SimpleCov.start
	SimpleCov.command_name 'Unit Tests'
  # t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

task default: %w[test]
