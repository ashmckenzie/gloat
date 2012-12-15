require File.expand_path('../config/initialisers/init', __FILE__)

require 'sinatra/base'
require "sinatra/reloader"
require 'sprockets'

run Gloat::App
