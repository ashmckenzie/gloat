module Gloat
  class Slides

    def initialize config
      @config = config
    end

    def slides
      number = 0
      header_regex = /^!SLIDE\s*/
      slide_regex = /(?m)#{header_regex}.*?(?=#{header_regex}|\Z)/

      @config.slides.inject([]) do |slides, file|
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

    def get number
      slides[number]
    end

    def for_json
      all_slides = slides

      {
        total: all_slides.count,
        slides: all_slides.map { |s| s.for_json }
      }
    end
  end
end
