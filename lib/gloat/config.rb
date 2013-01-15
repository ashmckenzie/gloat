require 'yaml'

module Gloat
  class Config

    attr_reader :settings

    def initialize config_file=default_config_file
      @settings = Hashie::Mash.new(YAML.load_file(config_file))
    end

    def default_config_file
      File.join(root_path, 'gloat.yaml')
    end

    def default_language
      @default_language ||= settings.fetch('default_language', 'textile')
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
      @themes_path ||= File.join(root_path, 'assets', 'themes')
    end

    def slides_path
      @slides_path ||= File.join(root_path, 'slides')
    end

    def method_missing symbol
      settings.send(symbol)
    end

    private

    def root_path
      File.expand_path(File.join('..', '..', '..'), __FILE__)
    end
  end
end
