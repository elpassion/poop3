require 'spec_helper'

describe Server::MessageHandler do
  using RSpec::Parameterized::TableSyntax

  subject { described_class.new(input).call }

  context "given PASS command" do
    context "with valid parameter" do
      where(:input, :output) do
        'PASS 123123' | '+OK maildrop locked and ready'
      end

      with_them do
        it 'returns success message' do
          expect(subject).to eq(output), "Fail on input '#{input}'"
        end
      end
    end

    context "with invalid parameter" do
      where(:input, :output) do
        'PASS' | '-ERR invalid password'
      end

      with_them do
        it 'returns error message' do
          expect(subject).to eq(output), "Fail on input '#{input}'"
        end
      end
    end
  end
end
