require 'spec_helper'

describe Server::MessageHandler do
  using RSpec::Parameterized::TableSyntax

  subject { described_class.new(input).call }

  context "given RSET command" do
    where(:input, :output) do
      'RSET' | '+OK maildrop has 2 messages (320 octets)'
    end

    with_them do
      it 'returns success message' do
        expect(subject).to eq(output), "Fail on input '#{input}'"
      end
    end
  end
end
