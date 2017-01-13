module Server
  class MessageHandler
    def initialize(message = nil)
      @message = message
    end

    def call
      return call_command if known_command?
      'Unknown command'
    end

    private

    attr_reader :message

    def call_command
      Server::MessageHandler.const_get(action).new.call
    end

    def known_command?
      Server::MessageHandler.const_defined? action
    end

    def action
      message.strip.to_s.split(' ')[0].strip.capitalize
    end

    class User
      def call
        "+OK User accepted, password please"
      end
    end
  end
end
