require 'spec_helper'

describe Server::MessageHandler do
  using RSpec::Parameterized::TableSyntax

  subject { described_class.new(input).call }

  context "given valid command" do
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
    end

    with_them do
      it 'returns valid response' do
        expect(subject).to eq(output), "Fail on input '#{input}'"
      end
    end
  end

  context "given invalid command" do
    where(:input, :output) do
      'Wrong command' | '-ERR Unknown command'
      'very bad command' | '-ERR Unknown command'
    end

    with_them do
      it 'returns unknown command message' do
        expect(subject).to eq(output), "Fail on input '#{input}'"
      end
    end
  end
end
