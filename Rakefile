require 'rake/rdoctask'

task :default => [:rdoc]

# See: http://rake.rubyforge.org/classes/Rake/RDocTask.html
Rake::RDocTask.new do |rd|
	rd.main = "doc/README.rdoc"
	rd.rdoc_files.include("doc/README.rdoc", "lib/**/*.rb", "examples/**/*.rb")
end

