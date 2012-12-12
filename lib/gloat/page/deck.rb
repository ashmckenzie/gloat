module Gloat
  module Page
    class Deck < Base

      attr_reader :deck

      def initialize config, deck, layout_name='deck'
        super(config, layout_name)
        @deck = deck
      end

      def slides
        @slides ||= Gloat::Slides.new(config, deck)
      end

      def slide_list_template
        @slide_list_template ||= File.read(File.join(view_path, 'templates', 'slide_list_template.erb'))
      end

      def slide_template
        @slide_template ||= File.read(File.join(view_path, 'templates', 'slide_template.erb'))
      end
    end
  end
end
