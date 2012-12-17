module Gloat
  module Page
    class StaticDeck < Deck

      def initialize config, deck_config, layout_name='static'
        super
        # super(config, layout_name)
        # @deck_config = deck_config
      end

      def deck
        @deck ||= Gloat::StaticDeck.new(config, @deck_config)
      end
    end
  end
end
