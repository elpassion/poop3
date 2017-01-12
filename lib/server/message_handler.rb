module Server
  class MessageHandler
    def initialize(message = nil)
      @message = message
    end

    def call
      return Server::MessageHandler.const_get(action).new.call if defined? action
      'Unknown command'
    end

    private

    attr_reader :message

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
