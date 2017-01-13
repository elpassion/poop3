require 'spec_helper'

describe Server::MessageHandler, "given NOOP command" do

  subject { described_class.new("NOOP").call }

  it 'returns success message' do
    expect(subject).to eq "+OK"
  end
end
