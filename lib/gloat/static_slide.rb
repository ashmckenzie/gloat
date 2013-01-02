module Gloat
  class StaticSlide < Slide

    def markup
      _markup = super

      # images
      #
      _markup.css('img').each do |x|
        next if !x.attribute('src') || x.attribute('src').value.match(/^http/)
        x.attribute('src').value = "../.." + x.attribute('src').value
      end

      # links
      #
      _markup.css('a').each do |x|
        next if !x.attribute('href') || x.attribute('href').value.match(/^http/)
        x.attribute('href').value = "." + x.attribute('href').value
      end

      _markup.to_s
    end
  end
end
