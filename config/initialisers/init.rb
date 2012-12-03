require 'bundler/setup'
Bundler.require(:default, :development)

require 'sinatra/base'
require "sinatra/reloader"
require 'sprockets'
require 'json'

dirs = [
  File.expand_path('../../../lib/gloat/support', __FILE__),
  File.expand_path('../../../lib/gloat', __FILE__),
]

dirs.each do |dir|
  Dir["#{dir}/*.rb"].each { |file| require file }
end
