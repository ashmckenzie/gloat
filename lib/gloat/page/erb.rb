module Gloat
  module Page
    class Erb < Base

      def initialize config, action, layout_name='default'
        super(config, layout_name)
        @action = action
      end

      def decks
        config.settings.decks
      end

      def content
        Tilt::ERBTemplate.new(File.join(view_path, "#{@action}.erb")).render(self)
      end
    end
  end
end
