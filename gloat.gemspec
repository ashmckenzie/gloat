# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'gloat/version'

Gem::Specification.new do |gem|
  gem.name          = "gloat"
  gem.version       = Gloat::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.authors       = ["Ash McKenzie"]
  gem.email         = ["ash@greenworm.com.au"]
  gem.description   = %q{Gloat - Show off your presentation using Markdown, Textile, HAML or whatever!}
  gem.summary       = %q{Gloat - Awesomely easy presentations}
  gem.homepage      = "https://github.com/ashmckenzie/gloat"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'sinatra', '~> 1.3'
  gem.add_dependency 'sinatra-contrib', '~> 1.3'
  gem.add_dependency 'sinatra-sprockets', '~> 0.0'
  gem.add_dependency 'tilt', '~> 1.3'
  gem.add_dependency 'RedCloth', '~> 4.2'
  gem.add_dependency 'rdiscount', '~> 1.6'
  gem.add_dependency 'erubis', '~> 2.7'
  gem.add_dependency 'nokogiri', '~> 1.5'
  gem.add_dependency 'coffee-script', '~> 2.2'
  gem.add_dependency 'sass', '~> 3.2'
  gem.add_dependency 'haml', '~> 3.1'
  gem.add_dependency 'hashie', '~> 1.2'
  gem.add_dependency 'thin', '~> 1.5'
  gem.add_dependency 'subby', '~> 0.0'

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 10.0'
end
