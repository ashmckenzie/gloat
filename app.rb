module Gloat

  class App < Sinatra::Base

    # Yuck.
    #
    config = Config.instance

    configure :development do
      register Sinatra::Reloader
      Dir[File.join(File.expand_path(File.join('..'), __FILE__), '**', '*.rb')].each do |file|
        also_reload file
      end
    end

    use Gloat::Support::SprocketsMiddleware, %r{/assets} do |env|
      env.append_path File.join(config.root_path, 'assets', 'stylesheets')
      env.append_path File.join(config.root_path, 'assets', 'javascripts')
      env.append_path File.join(config.root_path, 'assets', 'images')
      env.append_path File.join(config.root_path, 'assets', 'fonts')
      env.append_path File.join(config.root_path, 'assets', 'themes')
      env.append_path File.join(config.root_path, 'assets')

      env.append_path File.join(Dir.pwd, 'assets', 'themes')
      env.append_path File.join(Dir.pwd, 'assets')
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
        name: 'Available decks',
        description: 'Available decks to choose from',
        decks: decks
      }

      Gloat::Page::Basic.new('decks', data).render
    end

    get '/decks/:slug' do |slug|
      deck = config.deck_for_slug slug
      Gloat::Page::Deck.new(deck).render
    end

    get '/images/:image' do |image|
      send_file File.join(config.slides_images_path, image)
    end

    private

    def config
      Config.instance
    end

    def decks
      decks = config.decks
    end
  end
end
