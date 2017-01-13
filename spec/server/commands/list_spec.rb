require 'spec_helper'

describe Server::MessageHandler do
  using RSpec::Parameterized::TableSyntax

  subject { described_class.new(input).call }

  context 'given LIST command' do
    context 'without parameter' do
      where(:input, :output) do
        'LIST' | '+OK Mailbox scan listing follows\n1 102\n2 218'
      end

      with_them do
        it 'returns success message' do
          expect(subject).to eq(output), "Fail on input '#{input}'"
        end
      end
    end

    context 'with valid parameter' do
      where(:input, :output) do
        'LIST 2' | '+OK 2 218'
      end

      with_them do
        it 'returns success message' do
          expect(subject).to eq(output), "Fail on input '#{input}'"
        end
      end
    end

    context 'with invalid parameter' do
      where(:input, :output) do
        'LIST 3' | '-ERR no such message, only 2 messages in maildrop'
      end

      with_them do
        it 'returns error message' do
          expect(subject).to eq(output), "Fail on input '#{input}'"
        end
      end
    end


  end
end
