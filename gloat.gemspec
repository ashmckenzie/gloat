# -*- encoding: utf-8 -*-
lib = File.expand_path(File.join('..', 'lib'), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'gloat/version'

Gem::Specification.new do |gem|
  gem.name          = "gloat"
  gem.version       = Gloat::VERSION
  gem.authors       = ["Ash McKenzie"]
  gem.email         = ["ash@greenworm.com.au"]
  gem.description   = %q{Gloat - Show off your presentation using Markdown, Textile, HAML or whatever!}
  gem.summary       = %q{Gloat - Awesomely easy presentations}
  gem.homepage      = "https://github.com/ashmckenzie/gloat"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'sinatra'
  gem.add_dependency 'sinatra-contrib'
  gem.add_dependency 'sinatra-sprockets'
  gem.add_dependency 'tilt'
  gem.add_dependency 'RedCloth'
  gem.add_dependency 'rdiscount'
  gem.add_dependency 'erubis'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'coffee-script'
  gem.add_dependency 'sass'
  gem.add_dependency 'haml'
  gem.add_dependency 'hashie'
  gem.add_dependency 'activesupport'
  gem.add_dependency 'thin'
  gem.add_dependency 'rake'
end
