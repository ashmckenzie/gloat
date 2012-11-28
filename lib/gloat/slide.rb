module Gloat
  class Slide

    attr_reader :number, :template_name

    def initialize config,number, raw_options, raw_markup, template_name='default'
      @config = config
      @number = number
      @raw_markup = raw_markup
      @raw_options = raw_options
      @template_name = template_name
    end

    def options
      @options ||= begin
        h = @raw_options.scan(/([^=]+)="([^"]+)"/).inject({}) { |hash, item| hash[item[0]] = item[1]; hash }
        Hashie::Mash.new(h)
      end
    end

    def markup
      @markup ||= begin
        case language
          when 'textile' then Tilt::RedClothTemplate.new { @raw_markup }.render
          when 'markdown' then Tilt::RDiscountTemplate.new { @raw_markup }.render
          when 'haml' then Tilt::HamlTemplate.new { @raw_markup }.render
        end
      end
    end

    def language
      options.fetch('language', @config.default_language)
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
      File.expand_path(File.join('..', '..', '..', 'views', 'templates', "#{template_name}.erb"), __FILE__)
    end
  end
end
