module Gloat
  module Page
    class Deck < Base

      def initialize config, deck_name, layout_name='deck'
        super(config, layout_name)
        @deck_name = deck_name
      end

      def deck
        @deck ||= Gloat::Deck.new(config, @deck_name)
      end

      def slide_list_template
        @slide_list_template ||= File.read(File.join(template_path, 'slide_list_template.erb'))
      end

      def slide_template
        @slide_template ||= File.read(File.join(template_path, 'slide_template.erb'))
      end
    end
  end
end
