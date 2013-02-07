module Gloat
  class StaticDeck < Deck

    protected

    def parse_slide_file file
      File.read(file).scan(SLIDE_REGEX).map do |content|
        Gloat::StaticSlide.new(content, Pathname.new(file).extname.gsub(/^\./, ''))
      end
    end
  end
end
