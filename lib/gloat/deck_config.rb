module Gloat
  class DeckConfig

    attr_reader :deck

    def initialize config, slug
      @config = config
      @deck = config.decks.detect { |x| x.slug == slug }
      raise "Cannot find deck '#{slug}'" unless @deck
    end

    def slug
      @deck.fetch('slug')
    end

    def name
      @deck.fetch('name')
    end

    def theme
      @deck.fetch('theme', 'default')
    end

    def slide_files
      @deck.slides.inject([]) do |slides, entry|
        if File.directory?(entry)
          candidate_entries = Dir[File.join(@config.slides_path, entry, '*')]
        else
          candidate_entries = [ File.join(@config.slides_path, entry) ]
        end
        slides += extract_valid_slide_files(candidate_entries)
      end
    end

    private

    def extract_valid_slide_files candidate_entries
      candidate_entries.inject([]) do |slides, entry|
        slides << entry if Gloat::Slide.slide_file_valid?(entry)
        slides
      end
    end
  end
end
