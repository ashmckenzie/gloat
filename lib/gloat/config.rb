require 'yaml'

module Gloat
  class Config

    attr_reader :settings

    def initialize
      @settings = Hashie::Mash.new(
        YAML.load_file(
          File.expand_path(File.join('..', '..', '..', 'config', 'gloat.yaml'), __FILE__)
        )
      )
    end

    def default_language
      @default_language ||= settings.fetch('default_language', 'textile')
    end
  end
end
