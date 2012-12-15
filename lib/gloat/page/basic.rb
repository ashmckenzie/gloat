module Gloat
  module Page
    class Basic < Base

      def initialize config, action, data, layout_name='basic'
        super(config, layout_name)
        @action = action
        @data = data
      end

      def content
        Tilt::ERBTemplate.new(File.join(view_path, "#{@action}.erb")).render(self, @data)
      end
    end
  end
end
