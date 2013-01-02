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

      def header
        Tilt::ERBTemplate.new(header_file).render(self) if header_file
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

      def decks_index_path
        '/decks'
      end

      private

      def header_file
        file = File.join(config.themes_path, theme, '_header.html.erb')
        if File.exist?(file)
          file
        else
          nil
        end
      end

      def footer_file
      end
    end
  end
end
