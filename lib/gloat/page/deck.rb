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

      def footer
        Tilt::ERBTemplate.new(footer_file).render(self) if footer_file
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

      def application_js
        '/assets/application.js'
      end

      def application_css
        '/assets/application.css'
      end

      def theme_css
        "/assets/themes/#{theme}/style.css"
      end

      private

      def config
        Config.instance
      end

      def header_file
        local_or_theme_partial '_header.html.erb'
      end

      def footer_file
        local_or_theme_partial '_footer.html.erb'
      end

      def local_or_theme_partial file
        [
          File.join(config.themes_path, theme, file),
          File.join(config.local_themes_path, theme, file)
        ].each do |file|
          return file if File.exist?(file)
        end
        false
      end
    end
  end
end
