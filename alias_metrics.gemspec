lib = File.dirname(__FILE__) + '/../lib/'
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |spec|
  spec.name = 'alias_metrics'
  spec.version = '0.1'
  spec.summary = "This tool is to visualize alias usage to parse command history. You can evaluate whether you use alias efficiently or not."
  spec.author = ["Kohei Tomita"]
  spec.email  = "tommy.fmale@gmail.com"
  spec.executables        = %w(alias_metrics)
  spec.files              = `git ls-files`.split("\n") rescue ''
end
