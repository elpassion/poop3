require 'spec_helper'
require 'base64'

describe Server::MessageHandler do
  using RSpec::Parameterized::TableSyntax

  subject { described_class.new(input).call }

  context 'given RETR command' do
    context 'with valid parameter' do
      where(:input, :output) do
        'RETR 1' | "+OK 102 octets\r\n#{Base64.encode64('This is first message')}."
        'RETR 2' | "+OK 218 octets\r\n#{Base64.encode64('This is second message')}."
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
