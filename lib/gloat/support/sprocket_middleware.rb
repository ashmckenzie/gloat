module Gloat
  module Support
    class SprocketsMiddleware
      attr_reader :app, :prefix, :sprockets

      def initialize(app, prefix, root='.')
        @app = app
        @prefix = prefix
        @sprockets = Sprockets::Environment.new(root)

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
  end
end
