require 'yaml'

module Gloat
  class Config

    SLIDE_EXTENSION = 'slide'

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

    def slides
      raise 'No slides configured!' unless settings.slides
      settings.slides.inject([]) do |slides, entry|
        if File.directory?(entry)
          slides += Dir[File.expand_path(File.join('..', '..', '..', entry, '*.slide'), __FILE__)]
        else
          if Pathname.new(entry).extname.gsub(/^\./, '') == SLIDE_EXTENSION
            slides << File.expand_path(File.join('..',  '..', '..', entry), __FILE__)
          end
        end
        slides
      end
    end
  end
end
