require 'fileutils'
require 'sprockets'

module Gloat
  class Static

    attr_reader :config

    def initialize config
      @config = config
    end

    def generate
      FileUtils.mkdir_p(File.join(tmp_dir, 'assets', 'themes', deck.theme))

      File.open(File.join(tmp_dir, 'index.html'), 'w') do |file|

        markup = Nokogiri::HTML(deck.render)

        markup.css('link').each do |x|
          next if !x.attribute('href') || x.attribute('href').value.match(/^http/)
          x.attribute('href').value = "." + x.attribute('href').value
        end

        markup.css('script').each do |x|
          next if !x.attribute('src') || x.attribute('src').value.match(/^http/)
          x.attribute('src').value = "." + x.attribute('src').value
        end

        file.write markup.to_s
      end

      %W{ vendor.js application.js base.css vendor.css application.css themes/#{deck.theme}/style.css themes/#{deck.theme}/background.png }.each do |file|
        File.open(File.join(tmp_dir, 'assets', file), 'w') do |f|
          f.write env[file].to_s
        end
      end

      FileUtils.cp_r File.join(root_dir, 'slides', 'images'), File.join(tmp_dir, 'images')

      FileUtils.cp_r Dir[File.join(assets_dir, 'images', '*')], File.join(tmp_dir, 'assets')
      FileUtils.cp_r Dir[File.join(assets_dir, 'fonts', '*')], File.join(tmp_dir, 'assets')
    end

    private

    def deck_config
      # FIXME
      Gloat::DeckConfig.new(config, 'operations-at-hooroo')
    end

    def deck
      @deck ||= Gloat::Page::Deck.new(config, deck_config, 'static')
    end

    def root_dir
      @root_dir ||= File.expand_path(File.join('..', '..', '..'), __FILE__)
    end

    def assets_dir
      @assets_dir ||= File.join(root_dir, 'assets')
    end

    def tmp_dir
      @tmp_dir ||= File.join(root_dir, 'tmp')
    end

    def setup_sprockets

    end

    def env
      @env ||= begin
        env = Sprockets::Environment.new
        env.append_path File.join(assets_dir, 'stylesheets')
        env.append_path File.join(assets_dir, 'javascripts')
        env.append_path File.join(assets_dir, 'images')
        env.append_path File.join(assets_dir, 'fonts')
        env.append_path File.join(assets_dir)
        env
      end
    end
  end
end
