module Gloat
  module Page
    class Basic < Base

      attr_reader :name, :author, :description

      def initialize action, data
        super 'basic'
        @action = action
        @data = data

        @name = data.fetch(:name, '')
        @description = data.fetch(:description, '')
        @author = data.fetch(:author, '')
      end

      def content
        Nokogiri::HTML.fragment(Tilt::ERBTemplate.new(File.join(views_path, "#{@action}.erb")).render(self, @data))
      end
    end
  end
end
