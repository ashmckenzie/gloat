module Gloat
  class Slide

    VALID_EXTENSIONS = %w{ slide textile md haml erb html }

    attr_reader :number, :template_name

    def initialize config, number, raw_options, raw_markup, extension, template_name='default'
      @config = config
      @number = number
      @raw_options = raw_options
      @raw_markup = raw_markup
      @extension = extension
      @template_name = template_name
    end

    def self.file_valid? filename
      file = Pathname.new(filename)
      file.exist? && VALID_EXTENSIONS.include?(file.extname.gsub(/^\./, ''))
    end

    def options
      @options ||= begin
        Hashie::Mash.new(
          @raw_options.scan(/([^=]+)="([^"]+)"/).inject({}) { |hash, item| hash[item[0]] = item[1]; hash }
        )
      end
    end

    def markup &blk
      @markup ||= begin

        if @extension == 'slide' || language != @config.default_language
          lang = language
        else
          lang = @extension
        end

        markup = case lang
          when 'textile' then Tilt::RedClothTemplate.new { @raw_markup }.render
          when 'haml' then Tilt::HamlTemplate.new { @raw_markup }.render
          when 'erb' then Tilt::ErubisTemplate.new { @raw_markup.gsub(/<.+>\n* */) { |m| m.gsub(/>\n* *$/, '>') } }.render
          when 'html' then @raw_markup
          when /markdown|md/ then Tilt::RDiscountTemplate.new { @raw_markup }.render
          else raise 'Unknown language'
        end

        Nokogiri::HTML::fragment(markup)
      end
    end

    def for_json
      {
        number: number,
        css_classes: options.classes,
        html: render.to_s
      }
    end

    def for_json_static
      {
        number: number,
        css_classes: options.classes,
        html: rewrite_markup(render).to_s
      }
    end

    def render
      @render ||= begin
        Nokogiri::HTML::fragment(template.render(self))
      end
    end

    private

    def rewrite_markup markup

      # images
      #
      markup.css('img').each do |x|
        next if !x.attribute('src') || x.attribute('src').value.match(/^http/)
        x.attribute('src').value = "." + x.attribute('src').value
      end

      # links
      #
      markup.css('a').each do |x|
        next if !x.attribute('href') || x.attribute('href').value.match(/^http/)
        x.attribute('href').value = "." + x.attribute('href').value
      end

      markup.to_s
    end

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
