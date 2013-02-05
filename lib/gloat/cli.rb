module Gloat
  class CLI

    def self.start
      begin
        subby = Subby.setup do

          command :receive do
            description 'Receive bumps'
            parameter :server, 'Server to connect to', format: /^http/, required: true
          end

          # command :send do
          #   description 'Send bumps'
          #   parameter :server, 'Server to connect to', format: /^http/, required: true
          #   parameter :key, 'Key to use', format: /^\w+-\w+-\w+-\w+-\w+$/, required: true
          # end
        end
      rescue => e
        p e
      end
    end
  end
end
