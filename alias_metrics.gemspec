Gem::Specification.new do |spec|
  spec.name        = 'alias_metrics'
  spec.version     = '0.1.2'
  spec.summary     = "This tool is to visualize alias usage to parse command history. You can evaluate whether you use alias efficiently or not."
  spec.author      = ["Kohei Tomita"]
  spec.email       = "tommy.fmale@gmail.com"
  spec.executables = %w(alias_metrics alias_candidates)
  spec.files       = `git ls-files`.split("\n") rescue ''
  spec.homepage    = "https://github.com/tomity/alias_metrics"
  spec.add_development_dependency 'rspec', '~> 2.0'
  spec.add_development_dependency 'fuubar', "~> 1.0.0"
  spec.add_development_dependency "rake", "~> 0.9.2.2"
end
