module Gloat
  class Slide

    attr_reader :number, :options, :markup, :template_name

    def initialize number, options, content, template_name='default'
      @number = number
      @markup = Tilt::RedClothTemplate.new { content }.render
      @options = options
      @template_name = template_name
    end

    def render
      @render ||= begin
        template.render(self)
      end
    end

    private

    def template
      @template ||= Tilt::ERBTemplate.new(template_file)
    end

    def template_file
      File.expand_path(File.join('..', '..', '..', 'templates', "#{template_name}.erb"), __FILE__)
    end
  end
end
