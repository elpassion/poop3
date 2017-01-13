module Server
  class MessageHandler
    def initialize(message = nil)
      @message = message
    end

    def call
      return executive_command if know_command
      'Unknown command'
    end

    def know_command
      Server::MessageHandler.const_defined? action
    end

    def executive_command
      Server::MessageHandler.const_get(action).new.call
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
