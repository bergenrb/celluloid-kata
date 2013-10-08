require 'bundler/setup'

desc 'Open an irb session preloaded with this library'
task :console do
  sh 'irb -rubygems -I . -r pp -r kata'
end

task default: :console
