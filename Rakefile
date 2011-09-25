require 'rake/rdoctask'

task :default => [:rdoc]

# See: http://rake.rubyforge.org/classes/Rake/RDocTask.html
Rake::RDocTask.new do |rd|
	rd.main = "README.md"
	rd.rdoc_files.include("README.md", "lib/**/*.rb", "examples/**/*.rb")
end

