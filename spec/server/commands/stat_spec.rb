require 'spec_helper'

describe Server::MessageHandler do
  using RSpec::Parameterized::TableSyntax

  subject { described_class.new(input).call }

  context "given STAT command" do
    context "with valid parameter" do
      where(:input, :output) do
        'STAT' | '+OK 2 168'
      end

      with_them do
        it 'returns success message' do
          expect(subject).to eq(output), "Fail on input '#{input}'"
        end
      end
    end
  end
end
