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
      Gloat::Page.new(config, [], 'experiment').render
    end

    get '/slides' do
      content_type :json
      JSON(Gloat::Slides.new(config).for_json)
    end

    # get '/slide/:number' do
    #   content_type :json
    #   number = (params[:number].to_i - 1)
    #   JSON(Gloat::Slides.new(config).get(number).for_json)
    #   # slides[number].render
    # end

    get '/images/:image' do |image|
      send_file File.expand_path(File.join('..', '..', '..', 'slides', 'images', image), __FILE__)
    end

    private

    # def slides
    #   Gloat::Slides.new(config).slides
    # end

    def config
      Gloat::Config.new
    end
  end
end
