require 'rubygems'
require 'bundler'
require 'yaml'
require 'json'

Bundler.setup

lib_dir = File.expand_path(File.dirname(__FILE__))

dirs = [
  File.join('gloat', 'support'),
  File.join('gloat', 'page'),
  File.join('gloat')
]

dirs.each do |dir|
  path = File.expand_path(File.join(lib_dir, dir))
  Dir["#{path}/*.rb"].each { |file| require file }
end
