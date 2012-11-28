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

    def slides
      settings.slides.inject([]) do |slides, entry|
        if File.directory?(entry)
          slides += Dir[File.expand_path(File.join('..', '..', '..', entry, '*'), __FILE__)]
        else
          slides << File.expand_path(File.join('..',  '..', '..', entry), __FILE__)
        end
        slides
      end
    end
  end
end
