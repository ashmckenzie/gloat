module Gloat
  class CLI

    def self.start
      begin
        subby = Subby.setup do

          command :serve do
            description 'Serve presentation'
            parameter :port, 'Port to listen on', format: /\d+/
          end

          command :static do
            description 'Create a static version of the presentation'
            # FIXME: add :type support
            parameter :directory, 'Directory in which to create presentation', :type => :directory
          end
        end
      rescue => e
        raise
      end

      case subby.command.name
        when :serve
          App.run!

        when :static
          Static.new.generate
      end
    end
  end
end
