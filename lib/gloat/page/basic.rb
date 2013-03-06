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
        Nokogiri::HTML.fragment(template)
      end

      private

      attr_reader :data

      def template
        Tilt::ERBTemplate.new(template_file).render(self, data)
      end

      def template_file
        File.join(views_path, "#{@action}.erb")
      end
    end
  end
end
