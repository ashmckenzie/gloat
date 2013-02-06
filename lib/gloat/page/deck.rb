require 'forwardable'

module Gloat
  module Page
    class Deck < Base

      extend Forwardable

      def_delegators :@deck, :name, :description, :author, :slug, :theme

      def initialize deck
        super 'deck'
        @deck = deck
      end

      def header
        Tilt::ERBTemplate.new(header_file).render(self) if header_file
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

      def deck_as_json
        @deck.for_json.to_json
      end

      private

      def config
        Config.instance
      end

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
