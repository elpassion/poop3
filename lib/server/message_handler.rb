module Server
  class MessageHandler
    def initialize(message = nil)
      @message = message
    end

    def call
      return call_command if known_command?
      '-ERR Unknown command'
    end

    private

    attr_reader :message

    def call_command
      Server::MessageHandler.const_get(action).new(params).call
    end

    def known_command?
      Server::MessageHandler.const_defined? action
    end

    def action
      message.strip.to_s.split(' ')[0].strip.capitalize
    end

    def params
      message.strip.to_s.split(' ')[1..-1].map(&:strip)
    end

    class Command
      attr_reader :params

      def initialize(params = [])
        @params = params
      end
    end

    class User < Command
      def call
        return "+OK User accepted, password please" if params.any?

        "-ERR No parameter provided"
      end
    end

    class Pass < Command
      def call
        return "+OK maildrop locked and ready" if params.any?

        "-ERR invalid password"
      end
    end

    class Stat < Command
      def call
        '+OK 2 320'
      end
    end
  end
end
