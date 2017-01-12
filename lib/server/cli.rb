require 'socket'
require 'server/message_handler'
require 'server/connection'

module Server
  class Cli
    def self.run
      server = TCPServer.new 1100

      loop do
        Thread.start(server.accept) do |client|
          connection = Server::Connection.new

          client.puts connection.handshake

          client.puts connection.on_message(client.gets)

          client.close
        end
      end
    end
  end
end