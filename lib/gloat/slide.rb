module Gloat
  class Slide

    VALID_EXTENSIONS = %w{ slide textile md haml erb html }

    attr_reader :template_name

    def initialize content, extension, template_name='default'
      @extension = extension
      @template_name = template_name

      parse_slide(content)
    end

    def self.slide_file_valid? filename
      file = Pathname.new(filename)
      file.exist? && VALID_EXTENSIONS.include?(file.extname.gsub(/^\./, ''))
    end

    def options
      @options ||= begin
        Hashie::Mash.new(
          @raw_options.scan(/\s*([^=]+)="([^"]+)"/).inject({}) { |hash, item| hash[item[0]] = item[1]; hash }
        )
      end
    end

    def markup
      @markup ||= begin

        if @extension == 'slide' || language != config.default_language
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

        Nokogiri::HTML::fragment(emojify(markup))
      end
    end

    def for_json
      {
        options: options,
        html: render.to_s
      }
    end

    def render
      @render ||= begin
        Nokogiri::HTML::fragment(template.render(self))
      end
    end

    private

    def config
      Config.instance
    end

    def parse_slide content
      if match = content.match(/^!SLIDE\s?(?<raw_options>[^\n]*)\n\n(?<raw_markup>[^\n].*)$/m)
        @raw_options = match['raw_options']
        @raw_markup = match['raw_markup']
        self
      else
        raise "Unable to create Gloat::Slide from '#{content}'"
      end
    end

    def language
      options.fetch('language', config.default_language)
    end

    def template
      @template ||= Tilt::ERBTemplate.new(template_file)
    end

    def template_file
      File.expand_path(File.join('..', '..', '..', 'views', 'templates', "#{template_name}.erb"), __FILE__)
    end

    def emojify markup=''
      markup.gsub(/\s*:([a-z0-9\+\-_]+):\s*/) do |match|
        if is_emoji?($1)
          %Q{<img alt="#{$1}" src="/assets/emoji/#{$1}.png" class="emoji" />}
        else
          match
        end
      end
    end

    def is_emoji? file
      available_emojis.include? file
    end

    def available_emojis
      @available_emojis ||= Dir["#{config.images_path}/emoji/*.png"].sort.map { |f| File.basename(f, '.png') }
    end
  end
end
