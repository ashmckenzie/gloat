module Gloat

  class App < Sinatra::Base

    configure :development do
      register Sinatra::Reloader
      Dir[File.join(File.expand_path(File.join('..', '..'), __FILE__), '**', '*.rb')].each do |file|
        also_reload file
      end
    end

    set :views, File.expand_path(File.join('..', '..', '..', 'views'), __FILE__)
    set :public_folder, File.expand_path(File.join('..', '..', '..', 'public'), __FILE__)

    use Gloat::Support::SprocketsMiddleware, %r{/assets} do |env|
      env.append_path "assets/stylesheets"
      env.append_path "assets/javascripts"
      env.append_path "assets/images"
      env.append_path "assets/fonts"
    end

    get '/' do
      config = Gloat::Config.new
      slides = Gloat::Slides.new(config).slides
      Gloat::Page.new(config, slides).render
    end

    get '/images/:image' do |image|
      send_file File.expand_path(File.join('..', '..', '..', 'slides', image), __FILE__)
    end
  end
end
