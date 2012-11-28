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
          if m = s.match(/^!SLIDE\s*(?<options>[^\n]*)\n\n(?<raw>[^\n].*)$/m)
            number += 1
            slides << Gloat::Slide.new(@config, number, m['options'], m['raw'])
          end
        end
        slides
      end
    end
  end
end
