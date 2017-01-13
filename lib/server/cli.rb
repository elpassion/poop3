require 'socket'
require 'server/message_handler'
require 'server/connection'

module Server
  class Cli
    def self.run
      server = TCPServer.new 1100

      Thread.abort_on_exception = true

      loop do
        Thread.start(server.accept) do |client|
          connection = Server::Connection.new
          begin
            client.puts connection.handshake
            loop do
              client.puts connection.on_message(client.gets)
            end
          rescue
            # do nothing
          ensure
            client.close
          end
        end
      end
    end
  end
end
