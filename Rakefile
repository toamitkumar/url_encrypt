require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rubygems'
require 'echoe'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the url_encrypt plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the url_encrypt plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'UrlEncrypt'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Echoe.new('url_encrypt', '0.1.0') do |p|
  p.description     = "Encrypt your URLs"
  p.url             = "http://github.com/toamitkumar/url_encrypt"
  p.author          = "Amit Kumar"
  p.email           = "toamitkumar@gmail.com"
  p.ignore_pattern  = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
