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
          STDOUT.puts "Connection established with #{client.addr}"

          connection = Server::Connection.new
          begin
            puts(client, connection.handshake)
            loop do
              puts(client, connection.on_message(client.gets))
            end
          rescue
            # do nothing
          ensure
            client.close
          end
        end
      end
    end

    def self.puts(client, message)
      client.print "#{message}\r\n"
    end
  end
end
