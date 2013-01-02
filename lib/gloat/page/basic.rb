module Gloat
  module Page
    class Basic < Base

      def initialize config, action, data, layout_name='basic'
        super(config, layout_name)
        @action = action
        @data = data
      end

      def content
        Nokogiri::HTML.fragment(Tilt::ERBTemplate.new(File.join(views_path, "#{@action}.erb")).render(self, @data))
      end
    end
  end
end
