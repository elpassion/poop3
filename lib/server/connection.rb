module Server
  class Connection
    def handshake
      "+OK POP3 localhost v#{Server::VERSION} server ready"
    end

    def on_message(message)
      Server::MessageHandler.new(message).call
    end
  end
end