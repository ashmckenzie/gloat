require 'bundler/setup'
Bundler.require(:default, :development)

require 'json'

dirs = [
  File.expand_path('../../../lib/gloat/support', __FILE__),
  File.expand_path('../../../lib/gloat/page', __FILE__),
  File.expand_path('../../../lib/gloat', __FILE__),
]

dirs.each do |dir|
  Dir["#{dir}/*.rb"].each { |file| require file }
end
