require File.expand_path(File.join('..', 'config', 'initialisers', 'init'), __FILE__)

desc 'Create a static version of your presentation'
task :static do
  config = Gloat::Config.new
  Gloat::Static.new(config).generate
end
