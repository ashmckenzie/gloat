module Gloat

  class App < Sinatra::Base

    configure :development do
      register Sinatra::Reloader
      Dir[File.join(File.expand_path(File.join('..', '..'), __FILE__), '**', '*.rb')].each do |file|
        also_reload file
      end
    end

    use Gloat::Support::SprocketsMiddleware, %r{/assets} do |env|
      env.append_path "assets/stylesheets"
      env.append_path "assets/javascripts"
      env.append_path "assets/images"
      env.append_path "assets/fonts"
      env.append_path "assets"
    end

    get '/' do
      if decks.size > 1
        redirect '/decks'
      else
        redirect "/decks/#{decks.first.slug}"
      end
    end

    get '/decks' do
      Gloat::Page::Basic.new(config, 'decks', { decks: decks }).render
    end

    get '/decks/:deck_slug' do |deck_slug|
      deck = Gloat::DeckConfig.new(config, deck_slug)
      Gloat::Page::Deck.new(config, deck).render
    end

    get '/images/:image' do |image|
      send_file File.join(config.slides_images_path, image)
    end

    private

    def config
      @config ||= Gloat::Config.new
    end

    def decks
      decks = config.decks
    end
  end
end
