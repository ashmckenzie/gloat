require 'active_support/all'

module Gloat
  class Page

    attr_reader :config, :layout_name

    def initialize config, layout_name='default'
      @config = config
      @layout_name = layout_name
    end

    def render
      layout.render(self)
    end

    def header
    end

    def footer
    end

    def title
      config.settings.name
    end

    def description
      config.settings.description
    end

    def author
      config.settings.author
    end

    def slides
      @slides ||= Gloat::Slides.new(config)
    end

    def slide_list_template
      @slide_list_template ||= File.read(File.join(view_path, 'templates', 'slide_list_template.erb'))
    end

    def slide_template
      @slide_template ||= File.read(File.join(view_path, 'templates', 'slide_template.erb'))
    end

    private

    def view_path
      @view_path ||= File.expand_path('../../../views', __FILE__)
    end

    def layout
      @layout ||= Tilt::ERBTemplate.new(layout_file)
    end

    def layout_file
      File.expand_path(File.join('..', '..', '..', 'views', 'layouts', "#{layout_name}.erb"), __FILE__)
    end
  end
end
