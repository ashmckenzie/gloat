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
      if config.settings.decks.size > 1
        Gloat::Page::Erb.new(config, 'index').render
      else
        redirect "/decks/#{config.settings.decks.first.slug}"
      end
    end

    get '/decks/:deck' do |deck|
      Gloat::Page::Deck.new(config, deck).render
    end

    get '/images/:image' do |image|
      send_file File.expand_path(File.join('..', '..', '..', 'slides', 'images', image), __FILE__)
    end

    private

    def config
      Gloat::Config.new
    end
  end
end
