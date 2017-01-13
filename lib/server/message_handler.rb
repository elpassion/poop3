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

    class List < Command
      def call
        case params[0]
          when '1'
            '+OK 1 102'
          when '2'
            '+OK 2 218'
          when nil
            "+OK Mailbox scan listing follows\n1 102\n2 218\n."
          else
            '-ERR no such message, only 2 messages in maildrop'
        end
      end
    end

    class Noop < Command
      def call
        '+OK'
      end
    end

    class Dele < Command
      def call
        return "+OK Message deleted" if params.any?

        "-ERR Invalid parameter"
      end
    end

    class Retr < Command
      def call
        case params[0]
          when '1'
            "+OK 102 octets\n#{Base64.encode64('This is first message')}.\n"
          when '2'
            "+OK 218 octets\n#{Base64.encode64('This is second message')}.\n"
          else
            '-ERR no such message'
        end
      end
    end

    class Rset < Command
      def call
        '+OK maildrop has 2 messages (320 octets)'
      end
    end

    class Quit < Command
      def call
        '+OK dewey POP3 localhost v0.1.0 server signing off'
      end
    end
  end
end
