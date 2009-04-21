require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.platform  =   Gem::Platform::RUBY
    gemspec.name      =   "rudoku"
    gemspec.version   =   "0.1"
    gemspec.author    =   "Reto Schüttel"
    gemspec.email     =   "reto <hugh> at <yoh!> schuettel doto ch"
    gemspec.summary   =   "Sudoku Engine."
    gemspec.description = "Rudoku is a simple Sudoku solver."
    gemspec.requirements << 'none'
    gemspec.homepage  = "http://github.com/retoo/rudoku"
    gemspec.files     =   FileList['lib/*.rb'].to_a
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
  raise e
end

# require 'rake/testtask'
# Rake::TestTask.new(:test) do |test|
#   test.libs << 'lib' << 'test'
#   test.pattern = 'test/**/*_test.rb'
#   test.verbose = true
# end
#
# begin
#   require 'rcov/rcovtask'
#   Rcov::RcovTask.new do |test|
#     test.libs << 'test'
#     test.pattern = 'test/**/*_test.rb'
#     test.verbose = true
#   end
# rescue LoadError
#   task :rcov do
#     abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
#   end
# end


task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rudoku #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
