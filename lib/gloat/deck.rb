module Gloat
  class Deck

    HEADER_REGEX = /^!SLIDE\s*/
    SLIDE_REGEX = /(?m)#{HEADER_REGEX}.*?(?=#{HEADER_REGEX}|\Z)/

    def initialize attributes
      @attributes = attributes
    end

    def slug
      @attributes.fetch('slug')
    end

    def name
      @attributes.fetch('name', 'Name not defined')
    end

    def description
      @attributes.fetch('description', 'Description not defined')
    end

    def author
      @attributes.fetch('author', 'Author not defined')
    end

    def theme
      @attributes.fetch('theme', 'default')
    end

    def for_json
      slides_with_numbers = slides.each_with_index.map do |s, i|
        slide_as_json = s.for_json
        slide_as_json['number'] = i + 1
        slide_as_json
      end

      {
        firstSlideNumber: 1,
        slides: slides_with_numbers
      }
    end

    private

    def config
      Config.instance
    end

    def slides
      slide_files.inject([]) do |slides, file|
        slides + parse_slide_file(file)
      end
    end

    def slide_files
      @attributes.slides.inject([]) do |slides, entry|
        if File.directory?(entry)
          candidate_entries = Dir[File.join(config.slides_path, entry, '*')]
        else
          candidate_entries = [ File.join(config.slides_path, entry) ]
        end
        slides += extract_valid_slide_files(candidate_entries)
      end
    end

    def extract_valid_slide_files candidate_entries
      candidate_entries.inject([]) do |slides, entry|
        slides << entry if Gloat::Slide.slide_file_valid?(entry)
        slides
      end
    end

    def parse_slide_file file
      File.read(file).scan(SLIDE_REGEX).map do |content|
        Gloat::Slide.new(content, Pathname.new(file).extname.gsub(/^\./, ''))
      end
    end
  end
end
