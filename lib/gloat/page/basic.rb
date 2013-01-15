module Gloat
  module Page
    class Basic < Base

      attr_accessor :title, :author, :description

      def initialize config, action, data, layout_name='basic'
        super(config, layout_name)
        @action = action
        @data = data

        @title = data.fetch(:title, '')
        @description = data.fetch(:description, '')
        @author = data.fetch(:author, '')
      end

      def content
        Nokogiri::HTML.fragment(Tilt::ERBTemplate.new(File.join(views_path, "#{@action}.erb")).render(self, @data))
      end
    end
  end
end
