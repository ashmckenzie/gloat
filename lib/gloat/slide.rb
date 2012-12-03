module Gloat
  class Slide

    attr_reader :number, :template_name

    def initialize config, number, raw_options, raw_markup, extension, template_name='default'
      @config = config
      @number = number
      @raw_options = raw_options
      @raw_markup = raw_markup
      @extension = extension
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

        if @extension == 'slide' || language != @config.default_language
          check = language
        else
          check = @extension
        end

        case check
          when 'textile' then Tilt::RedClothTemplate.new { @raw_markup }.render
          when 'haml' then Tilt::HamlTemplate.new { @raw_markup }.render
          when 'erb' then Tilt::ErubisTemplate.new { @raw_markup.gsub(/<.+>\n* */) { |m| m.gsub(/>\n* *$/, '>') } }.render
          when 'html' then @raw_markup
          when /markdown|md/ then Tilt::RDiscountTemplate.new { @raw_markup }.render
          else raise 'Unknown language'
        end
      end
    end

    def for_json
      markup = render

      {
        number: number,
        css_classes: @options.classes,
        html: markup
      }
    end

    def render
      @render ||= begin
        template.render(self)
      end
    end

    private

    def language
      options.fetch('language', @config.default_language)
    end

    def template
      @template ||= Tilt::ERBTemplate.new(template_file)
    end

    def template_file
      File.expand_path(File.join('..', '..', '..', 'views', 'templates', "#{template_name}.erb"), __FILE__)
    end
  end
end
