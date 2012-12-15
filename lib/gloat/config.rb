require 'yaml'

module Gloat
  class Config

    attr_reader :settings

    def initialize config_file=default_config_file
      @settings = Hashie::Mash.new(YAML.load_file(config_file))
    end

    def default_config_file
      File.expand_path(File.join('..', '..', '..', 'config', 'gloat.yaml'), __FILE__)
    end

    def default_language
      @default_language ||= settings.fetch('default_language', 'textile')
    end

    def method_missing symbol
      settings.send(symbol)
    end
  end
end
