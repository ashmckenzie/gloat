module Gloat
  class DeckConfig

    attr_reader :deck

    def initialize config, slug
      @deck = config.decks.detect { |x| x.slug == slug }
    end
  end
end
