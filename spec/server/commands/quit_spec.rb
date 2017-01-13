require 'spec_helper'

describe Server::MessageHandler do
  using RSpec::Parameterized::TableSyntax

  subject { described_class.new(input).call }

  context "given QUIT command" do
    where(:input, :output) do
      'QUIT' | '+OK dewey POP3 localhost v0.1.0 server signing off'
    end

    with_them do
      it 'returns valid response' do
        expect(subject).to eq(output), "Fail on input '#{input}'"
      end
    end
  end
end
