require 'spec_helper'

describe Server::MessageHandler do using RSpec::Parameterized::TableSyntax

  where(:input, :output) do
    'User' | '+OK User accepted, password please'
    'user ' | '+OK User accepted, password please'
    'USER ' | '+OK User accepted, password please'
    "User\n" | '+OK User accepted, password please'
    "USER\r" | '+OK User accepted, password please'
    "uSER\r\n" | '+OK User accepted, password please'
    "\r\nuser" | '+OK User accepted, password please'
    ' user' | '+OK User accepted, password please'
    "uSER\r\n\r something" | '+OK User accepted, password please'
    'Wrong command' | 'Unknown command'
    'very bad command' | 'Unknown command'
  end

  with_them do
    it 'should works correctly' do
      expect(described_class.new(input).call).to eq(output), "Fail on input '#{input}'"
    end
  end
end
