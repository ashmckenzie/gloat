require 'sinatra/base'
require 'sinatra/reloader'
require 'sprockets'

require File.expand_path(File.join('..', 'lib', 'gloat'), __FILE__)

run Gloat::App
