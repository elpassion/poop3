require 'spec_helper'

describe Server::MessageHandler do
  using RSpec::Parameterized::TableSyntax

  subject { described_class.new(input).call }

  context "given USER command" do
    context "given valid command" do
      where(:input, :output) do
        'User Arek' | '+OK User accepted, password please'
        'user  Asia' | '+OK User accepted, password please'
        'USER Antoni' | '+OK User accepted, password please'
        "User Aleksy\n" | '+OK User accepted, password please'
        "USER User\r" | '+OK User accepted, password please'
        "uSER  Bob\r\n" | '+OK User accepted, password please'
        "\r\nuser Dan" | '+OK User accepted, password please'
        ' user   Ada' | '+OK User accepted, password please'
      end

      with_them do
        it 'returns valid response' do
          expect(subject).to eq(output), "Fail on input '#{input}'"
        end
      end
    end

    context "given valid command without valid parameter" do
      where(:input, :output) do
        'User' | '-ERR No parameter provided'
      end

      with_them do
        it 'returns parameter error message' do
          expect(subject).to eq(output), "Fail on input '#{input}'"
        end
      end
    end
  end
end
