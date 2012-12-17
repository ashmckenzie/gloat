module Gloat
  class Deck

    HEADER_REGEX = /^!SLIDE\s*/
    SLIDE_REGEX = /(?m)#{HEADER_REGEX}.*?(?=#{HEADER_REGEX}|\Z)/

    def initialize config, deck_config
      @config = config
      @deck_config = deck_config
    end

    def slides
      @deck_config.slide_files.inject([]) do |slides, file|
        slides + parse_slide_file(file)
      end
    end

    def for_json
      {
        total: slides.count,
        slides: slides.each_with_index.map { |s, i| x = s.for_json ; x['number'] = i+1 ; x }
      }
    end

    def theme
      deck.theme
    end

    def name
      deck.name
    end

    private

    def deck
      @deck ||= @deck_config.deck
    end

    protected

    def parse_slide_file file
      File.read(file).scan(SLIDE_REGEX).map do |content|
        Gloat::Slide.new(@config, content, Pathname.new(file).extname.gsub(/^\./, ''))
      end
    end
  end
end
