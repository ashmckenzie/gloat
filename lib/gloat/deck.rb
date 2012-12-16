module Gloat
  class Deck

    def initialize config, deck_config
      @config = config
      @deck_config = deck_config
    end

    def slides
      @slides ||= begin
        number = 0
        header_regex = /^!SLIDE\s*/
        slide_regex = /(?m)#{header_regex}.*?(?=#{header_regex}|\Z)/

        raw_slides.inject([]) do |slides, file|
          File.read(file).scan(slide_regex).each do |s|
            if m = s.match(/^!SLIDE\s?(?<options>[^\n]*)\n\n(?<raw>[^\n].*)$/m)
              number += 1
              extension = Pathname.new(file).extname.gsub(/^\./, '')
              slides << Gloat::Slide.new(@config, number, m['options'], m['raw'], extension)
            end
          end
          slides
        end
      end
    end

    def for_json
      {
        total: slides.count,
        slides: slides.map { |s| s.for_json }
      }
    end

    def for_json_static
      {
        total: slides.count,
        slides: slides.map { |s| s.for_json_static }
      }
    end

    def theme
      @theme ||= deck.fetch('theme', 'default')
    end

    def name
      @name ||= deck.fetch('name')
    end

    private

    def raw_slides
      raise 'No slides configured!' unless deck

      deck.slides.inject([]) do |slides, entry|
        if File.directory?(entry)
          entries = Dir[File.join(@config.slides_path, entry, '*')]
        else
          entries = [ File.join(@config.slides_path, entry) ]
        end
        slides += extract_valid_slides(entries)
      end
    end

    def deck
      @deck ||= @deck_config.deck
    end

    def extract_valid_slides entries
      entries.inject([]) do |slides, entry|
        slides << entry if Gloat::Slide.file_valid?(entry)
        slides
      end
    end
  end
end
