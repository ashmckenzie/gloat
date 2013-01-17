require 'bundler/gem_tasks'
require File.expand_path(File.join('..', 'lib', 'gloat'), __FILE__)

desc 'Create a static version of your presentation'
task :static do
  config = Gloat::Config.new
  Gloat::Static.new(config).generate
end
