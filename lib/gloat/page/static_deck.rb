module Gloat
  module Page
    class StaticDeck < Deck

      def deck
        @deck ||= Gloat::StaticDeck.new(config, @deck_config)
      end

      def decks_index_path
        '../../index.html'
      end
    end
  end
end
