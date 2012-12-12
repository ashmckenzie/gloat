require File.expand_path('../config/initialisers/init', __FILE__)

require 'fileutils'
require 'sprockets'

desc 'Create a static version of your presentation'
task :static do

  env = Sprockets::Environment.new
  env.append_path "assets/stylesheets"
  env.append_path "assets/javascripts"
  env.append_path "assets/images"
  env.append_path "assets/fonts"

  config = Gloat::Config.new

  FileUtils.mkdir_p('./tmp/assets')

  File.open('./tmp/index.html', 'w') do |file|

    markup = Nokogiri::HTML(Gloat::Page::Deck.new(config, 'operations-at-hooroo').render)

    markup.css('link').each do |x|
      next unless x.attribute('href')
      x.attribute('href').value = "." + x.attribute('href').value
    end

    markup.css('script').each do |x|
      next unless x.attribute('src')
      x.attribute('src').value = "." + x.attribute('src').value
    end

    file.write markup.to_s
  end

  %w{ vendor.js application.js base.css vendor.css application.css }.each do |file|
    File.open("./tmp/assets/#{file}", 'w') do |f|
      f.write env[file].to_s
    end
  end

  FileUtils.cp_r './slides/images', './tmp/images'

  FileUtils.cp_r Dir['./assets/images/*'], './tmp/assets/'
  FileUtils.cp_r Dir['./assets/fonts/*'], './tmp/assets/'
end
