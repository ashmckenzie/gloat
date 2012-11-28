module Gloat

  class SprocketsMiddleware
    attr_reader :app, :prefix, :sprockets

    def initialize(app, prefix)
      @app = app
      @prefix = prefix
      @sprockets = Sprockets::Environment.new

      yield sprockets if block_given?
    end

    def call(env)
      path_info = env["PATH_INFO"]
      if path_info =~ prefix
        env["PATH_INFO"].sub!(prefix, "")
        sprockets.call(env)
      else
        app.call(env)
      end
    ensure
      env["PATH_INFO"] = path_info
    end
  end

  class App < Sinatra::Base

    configure :development do
      register Sinatra::Reloader
      Dir[File.join(File.expand_path(File.join('..', '..'), __FILE__), '**', '*.rb')].each do |file|
        also_reload file
      end
    end

    set :views, File.expand_path(File.join('..', '..', '..', 'views'), __FILE__)
    set :public_folder, File.expand_path(File.join('..', '..', '..', 'public'), __FILE__)

    use SprocketsMiddleware, %r{/assets} do |env|
      env.append_path "assets/stylesheets"
      env.append_path "assets/javascripts"
      env.append_path "assets/images"
      env.append_path "assets/fonts"
    end

    get '/' do
      Gloat::Page.new(config, slides).render
    end

    private

    def config
      Gloat::Config.new
    end

    def slides
      number = 0
      slides = []
      header_regex = /^!SLIDE\s*/
      slide_regex = /(?m)#{header_regex}.*?(?=#{header_regex}|\Z)/

      config.slides.inject([]) do |slides, file|
        next unless File.exist?(file)
        File.read(file).scan(slide_regex).each do |s|
          m = s.match(/!SLIDE\s*(.*)\s*\n+(.+)\n*/)
          number += 1
          slides << Gloat::Slide.new(number, m[1], m[2])
        end
        slides
      end
    end
  end
end
