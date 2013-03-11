require 'fileutils'
require 'sprockets'

module Gloat
  class Static

    def generate
      generate_index
      config.static_decks.each { |deck| generate_deck deck }
    end

    def generate_index

      FileUtils.mkdir_p(File.join(static_path, 'assets'))

      File.open(File.join(static_path, 'index.html'), 'w') do |file|
        data = {
          name: 'Available decks',
          decks: config.decks,
          static_decks_path: static_decks_path
        }

        markup = Nokogiri::HTML(Gloat::Page::StaticBasic.new('static_decks', data).render)

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

    def generate_deck deck
      deck = Gloat::Page::StaticDeck.new(deck)
      deck_path = File.join(static_path, 'decks', deck.slug)

      FileUtils.mkdir_p(File.join(static_path, 'assets', 'themes', deck.theme))
      FileUtils.mkdir_p(deck_path)

      File.open(File.join(deck_path, 'index.html'), 'w') do |file|

        markup = Nokogiri::HTML(deck.render)

        # CSS
        markup.css('link').each do |x|
          next if !x.attribute('href') || x.attribute('href').value.match(/^http/)
          x.attribute('href').value = "../.." + x.attribute('href').value
        end

        # JavaScript
        markup.css('script').each do |x|
          next if !x.attribute('src') || x.attribute('src').value.match(/^http/)
          x.attribute('src').value = "../.." + x.attribute('src').value
        end

        file.write markup.to_s
      end

      %W{
        vendor.js
        application.js
        base.css
        vendor.css
        application.css
        local_application.css
        themes/#{deck.theme}/style.css
        themes/#{deck.theme}/background.png
        themes/#{deck.theme}/logo.png
      }.each do |file|
        File.open(File.join(static_path, 'assets', file), 'w') do |f|
          f.write env[file].to_s
        end
      end

      # Slide images
      FileUtils.cp_r images_path, File.join(static_path, 'images') if Dir.exist?(images_path)

      # Theme files
      theme_files = Dir[File.join(assets_path, 'themes', deck.theme, '*')].reject { |x| x.match(/\.(erb|haml|sass)$/) }
      FileUtils.cp_r theme_files, File.join(static_path, 'assets', 'themes', deck.theme)

      # Assets
      FileUtils.cp_r Dir[File.join(assets_path, 'images', '*')], File.join(static_path, 'assets')
      FileUtils.cp_r Dir[File.join(root_assets_path, 'images', '*')], File.join(static_path, 'assets')

      FileUtils.cp_r Dir[File.join(assets_path, 'fonts', '*')], File.join(static_path, 'assets')
      FileUtils.cp_r Dir[File.join(root_assets_path, 'fonts', '*')], File.join(static_path, 'assets')
    end

    private

    def config
      Config.instance
    end

    def root_path
      @root_path ||= File.expand_path(File.join('..', '..', '..'), __FILE__)
    end

    def current_path
      Dir.pwd
    end

    def assets_path
      @assets_path ||= File.join(current_path, 'assets')
    end

    def root_assets_path
      @root_assets_path ||= File.join(root_path, 'assets')
    end

    def static_path
      @static_path ||= File.join(current_path, 'static')
    end

    def static_decks_path
      @static_decks_path ||= File.join(static_path, 'decks')
    end

    def images_path
      @images_path ||= File.join(current_path, 'slides', 'images')
    end

    def env
      @env ||= begin
        env = Sprockets::Environment.new

        [ root_assets_path, assets_path ].each do |path|

          env.append_path File.join(path, 'stylesheets')
          env.append_path File.join(path, 'javascripts')
          env.append_path File.join(path, 'images')
          env.append_path File.join(path, 'themes')
          env.append_path File.join(path, 'fonts')
          env.append_path File.join(path)
        end

        env
      end
    end
  end
end
