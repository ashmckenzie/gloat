require 'fileutils'
require 'sprockets'

module Gloat
  class Static

    attr_reader :config

    def initialize config
      @config = config
    end

    def generate

      # Index
      #
      generate_index

      # Decks
      #
      config.decks.each do |deck|
        deck_config = Gloat::Config::Deck.new(config, deck.slug)
        generate_deck deck_config
      end
    end

    def generate_index

      FileUtils.mkdir_p(File.join(static_path, 'assets'))

      File.open(File.join(static_path, 'index.html'), 'w') do |file|
        data = {
          name: 'Available decks',
          decks: config.decks,
          decks_static_path: decks_static_path
        }

        markup = Nokogiri::HTML(Gloat::Page::StaticBasic.new(config, 'static_decks', data).render)

        # FIXME: Extract
        #
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

      %W{ basic.css }.each do |file|
        File.open(File.join(static_path, 'assets', file), 'w') do |f|
          f.write env[file].to_s
        end
      end
    end

    def generate_deck deck_config
      deck = Gloat::Page::StaticDeck.new(config, deck_config)
      deck_path = File.join(static_path, 'decks', deck_config.slug)

      FileUtils.mkdir_p(File.join(static_path, 'assets', 'themes', deck.theme))
      FileUtils.mkdir_p(deck_path)

      File.open(File.join(deck_path, 'index.html'), 'w') do |file|

        markup = Nokogiri::HTML(deck.render)

        # FIXME: Extract
        #

        # CSS
        #
        markup.css('link').each do |x|
          next if !x.attribute('href') || x.attribute('href').value.match(/^http/)
          x.attribute('href').value = "../.." + x.attribute('href').value
        end

        # JavaScript
        #
        markup.css('script').each do |x|
          next if !x.attribute('src') || x.attribute('src').value.match(/^http/)
          x.attribute('src').value = "../.." + x.attribute('src').value
        end

        file.write markup.to_s
      end

      %W{ vendor.js application.js base.css vendor.css application.css themes/#{deck.theme}/style.css themes/#{deck.theme}/background.png }.each do |file|
        File.open(File.join(static_path, 'assets', file), 'w') do |f|
          f.write env[file].to_s
        end
      end

      # Slide images
      #
      FileUtils.cp_r File.join(root_path, 'slides', 'images'), File.join(static_path, 'images')

      # Theme files
      theme_files = Dir[File.join(assets_path, 'themes', deck.theme, '*')].reject { |x| x.match(/\.(erb|haml|sass)$/) }
      FileUtils.cp_r theme_files, File.join(static_path, 'assets', 'themes', deck.theme)

      # Assets
      #
      FileUtils.cp_r Dir[File.join(assets_path, 'images', '*')], File.join(static_path, 'assets')
      FileUtils.cp_r Dir[File.join(assets_path, 'fonts', '*')], File.join(static_path, 'assets')
    end

    private

    def root_path
      @root_path ||= File.expand_path(File.join('..', '..', '..'), __FILE__)
    end

    def assets_path
      @assets_path ||= File.join(root_path, 'assets')
    end

    def static_path
      @static_path ||= File.join(root_path, 'static')
    end

    def decks_static_path
      @decks_static_path ||= File.join(static_path, 'decks')
    end

    def setup_sprockets

    end

    def env
      @env ||= begin
        env = Sprockets::Environment.new
        env.append_path File.join(assets_path, 'stylesheets')
        env.append_path File.join(assets_path, 'javascripts')
        env.append_path File.join(assets_path, 'images')
        env.append_path File.join(assets_path, 'fonts')
        env.append_path File.join(assets_path)
        env
      end
    end
  end
end
