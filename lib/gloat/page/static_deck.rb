module Gloat
  module Page
    class StaticDeck < Deck

      def deck
        @deck ||= Gloat::StaticDeck.new(config, @deck_config)
      end
    end
  end
end
