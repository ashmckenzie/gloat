module Gloat
  class Deck

    SLIDE_EXTENSIONS = %w{ slide textile md haml erb html }

    def initialize config, deck_name
      @config = config
      @deck_name = deck_name
    end

    def slides
      number = 0
      header_regex = /^!SLIDE\s*/
      slide_regex = /(?m)#{header_regex}.*?(?=#{header_regex}|\Z)/

      raw_slides.inject([]) do |slides, file|
        next unless File.exist?(file)
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

    def for_json
      all_slides = slides

      {
        total: all_slides.count,
        slides: all_slides.map { |s| s.for_json }
      }
    end

    def for_json_static
      all_slides = slides

      {
        total: all_slides.count,
        slides: all_slides.map { |s| s.for_json_static }
      }
    end

    private

    def raw_slides
      deck = deck_by_slug
      raise 'No slides configured!' unless deck

      deck.slides.inject([]) do |slides, entry|
        if File.directory?(entry)
          entries = Dir[File.expand_path(File.join('..', '..', '..', entry, '*'), __FILE__)]
        else
          entries = [ File.expand_path(File.join('..', '..', '..', entry), __FILE__) ]
        end
        slides += process_slides(entries)
      end
    end

    def deck_by_slug
      @config.decks.detect { |x| x.slug == @deck_name }
    end

    def process_slides entries
      entries.inject([]) do |slides, entry|
        if SLIDE_EXTENSIONS.include?(Pathname.new(entry).extname.gsub(/^\./, ''))
          slides << entry
        end
        slides
      end
    end
  end
end
