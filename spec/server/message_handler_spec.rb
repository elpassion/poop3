require 'spec_helper'

describe Server::MessageHandler do
  using RSpec::Parameterized::TableSyntax

  subject { described_class.new(input).call }

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
