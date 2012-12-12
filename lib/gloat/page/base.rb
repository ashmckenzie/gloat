require 'active_support/all'

module Gloat
  module Page
    class Base

      attr_reader :config, :layout_name

      def initialize config, layout_name
        @config = config
        @layout_name = layout_name
      end

      def render
        layout.render(self)
      end

      def header
      end

      def footer
      end

      def title
        config.settings.name
      end

      def description
        config.settings.description
      end

      def author
        config.settings.author
      end

      private

      def view_path
        @view_path ||= File.expand_path(File.join('..', '..', '..', '..', 'views'), __FILE__)
      end

      def layout
        @layout ||= Tilt::ERBTemplate.new(layout_file)
      end

      def layout_file
        File.expand_path(File.join(view_path, 'layouts', "#{layout_name}.erb"), __FILE__)
      end
    end
  end
end
