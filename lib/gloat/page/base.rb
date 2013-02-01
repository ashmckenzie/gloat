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

      private

      def views_path
        @views_path ||= config.views_path
      end

      def templates_path
        @templates_path ||= config.templates_path
      end

      def layouts_path
        @layouts_path ||= config.layouts_path
      end

      def layout
        @layout ||= Tilt::ERBTemplate.new(layout_file)
      end

      def layout_file
        @layout_file ||= File.join(layouts_path, "#{layout_name}.erb")
      end
    end
  end
end
