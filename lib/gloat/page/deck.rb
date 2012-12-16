module Gloat
  module Page
    class Deck < Base

      def initialize config, deck_config, layout_name='deck'
        super(config, layout_name)
        @deck_config = deck_config
      end

      def deck
        @deck ||= Gloat::Deck.new(config, @deck_config)
      end

      def theme
        deck.theme
      end

      def title
        deck.name
      end

      def slide_list_template
        @slide_list_template ||= File.read(File.join(templates_path, 'slide_list_template.erb'))
      end

      def slide_template
        @slide_template ||= File.read(File.join(templates_path, 'slide_template.erb'))
      end
    end
  end
end
