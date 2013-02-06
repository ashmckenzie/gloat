require 'singleton'

module Gloat
  class Config  < SimpleDelegator

    include Singleton

    def initialize config_file=default_config_file
      @settings = Hashie::Mash.new(YAML.load_file(config_file))
    end

    def default_config_file
      File.join(current_path, 'gloat.yaml')
    end

    def default_language
      @default_language ||= @settings.fetch('default_language', 'textile')
    end

    def slides_images_path
      @slides_images_path ||= File.join(root_path, 'slides', 'images')
    end

    def views_path
      @views_path ||= File.join(root_path, 'views')
    end

    def templates_path
      @templates_path ||= File.join(views_path, 'templates')
    end

    def layouts_path
      @layouts_path ||= File.join(views_path, 'layouts')
    end

    def themes_path
      @themes_path ||= File.join(assets_path, 'themes')
    end

    def local_themes_path
      @local_themes_path ||= File.join(current_path, 'assets', 'themes')
    end

    def assets_path
      @assets_path ||= File.join(root_path, 'assets')
    end

    def slides_path
      @slides_path ||= File.join(current_path, 'slides')
    end

    def decks
      @decks ||= begin
        @settings.decks.map do |deck_attributes|
          Deck.new(deck_attributes)
        end
      end
    end

    def deck_for_slug slug
      decks.detect { |deck| deck.slug == slug }
    end

    def current_path
      Dir.pwd
    end

    def root_path
      File.expand_path(File.join('..', '..', '..'), __FILE__)
    end
  end
end
