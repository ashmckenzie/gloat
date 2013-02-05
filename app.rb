module Gloat

  class App < Sinatra::Base

    # Yuck.
    #
    config = Gloat::Config.new

    configure :development do
      register Sinatra::Reloader
      Dir[File.join(File.expand_path(File.join('..'), __FILE__), '**', '*.rb')].each do |file|
        also_reload file
      end
    end

    use Gloat::Support::SprocketsMiddleware, %r{/assets}, config.root_path do |env|
      [ '', Dir.pwd ].each do |prefix|
        env.append_path File.join(prefix, 'assets', 'stylesheets')
        env.append_path File.join(prefix, 'assets', 'javascripts')
        env.append_path File.join(prefix, 'assets', 'images')
        env.append_path File.join(prefix, 'assets', 'fonts')
        env.append_path File.join(prefix, 'assets')
      end
    end

    get '/' do
      if decks.size > 1
        redirect '/decks'
      else
        redirect "/decks/#{decks.first.slug}"
      end
    end

    get '/decks' do
      data = {
        title: 'Available decks',
        description: 'Available decks to choose from',
        decks: decks
      }

      Gloat::Page::Basic.new(config, 'decks', data).render
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
