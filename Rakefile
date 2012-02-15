begin
    require 'rspec/core/rake_task'

      RSpec::Core::RakeTask.new(:spec) do |t|
            t.ruby_opts = '-w'
              end

        task :default => :spec
rescue LoadError
    raise 'RSpec could not be loaded. Run `bundle install` to get all development dependencies.'
end
