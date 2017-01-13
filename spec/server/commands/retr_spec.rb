require 'spec_helper'
require 'base64'

describe Server::MessageHandler do
  using RSpec::Parameterized::TableSyntax

  subject { described_class.new(input).call }

  context 'given RETR command' do
    context 'with valid parameter' do
      where(:input, :output) do
        'RETR 1' | "+OK 84 octets\r\nFrom: sender@poop3.com\r\nTo: You!\r\nSubject: Test message\r\n\r\nThis is a test message.\r\n\r\n."
        'RETR 2' | "+OK 84 octets\r\nFrom: sender@poop3.com\r\nTo: You!\r\nSubject: Test message\r\n\r\nThis is a test message.\r\n\r\n."
      end

      with_them do
        it 'returns success message' do
          expect(subject).to eq(output), "Fail on input '#{input}'"
        end
      end
    end

    context "with invalid parameter" do
      where(:input, :output) do
        'RETR' | '-ERR no such message'
        'RETR 3' | '-ERR no such message'
      end

      with_them do
        it 'returns error message' do
          expect(subject).to eq(output), "Fail on input '#{input}'"
        end
      end
    end
  end
end
