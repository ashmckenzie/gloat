require 'bundler/gem_tasks'
require File.expand_path(File.join('..', 'lib', 'gloat'), __FILE__)

desc 'Create a static version of your presentation'
task :static do
  Gloat::Static.new(Gloat::Config.instance).generate
end
