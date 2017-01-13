module Server
  class MessageHandler
    MESSAGE = <<~TEXT.gsub("\n", "\r\n")
        From: sender@poop3.com
        To: You!
        Subject: Test message

        This is a test message.
    TEXT

    def initialize(message = nil)
      puts message.inspect
      @message = message
    end

    def call
      return if message.nil? || message.empty?
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
        "+OK 2 #{2 * MESSAGE.size}"
      end
    end

    class List < Command
      def call
        case params[0]
          when '1'
            "+OK 1 #{MESSAGE.size}"
          when '2'
            "+OK 2 #{MESSAGE.size}"
          when nil
            "+OK Mailbox scan listing follows\r\n1 #{MESSAGE.size}\r\n2 #{MESSAGE.size}\r\n."
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
          when '1', '2'
            "+OK #{MESSAGE.size} octets\r\n#{MESSAGE}\r\n."
          else
            '-ERR no such message'
        end
      end
    end

    class Rset < Command
      def call
        "+OK maildrop has 2 messages (#{2 * MESSAGE.size} octets)"
      end
    end

    class Quit < Command
      def call
        '+OK dewey POP3 localhost v0.1.0 server signing off'
      end
    end

    class Capa < Command 
      def call
        "+OK Capability list follows\r\n" +
        "CAPA\r\n" + 
        "DELE\r\n" + 
        "LIST\r\n" + 
        "NOOP\r\n" + 
        "PASS\r\n" + 
        "QUIT\r\n" + 
        "RETR\r\n" + 
        "USER\r\n" + 
        "STAT\r\n" + 
        "RSET\r\n" +
        "."
        end 
      end
  end
end
