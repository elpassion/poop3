require 'spec_helper'

describe Server::MessageHandler, "DELE command" do

  subject { described_class.new(command).call }

  context "with valid parameter" do
    let(:command) { "DELE 1" }

    it "returns success message" do
      expect(subject).to eq "+OK Message deleted"
    end
  end

  context "without parameter" do
    let(:command) { "DELE" }

    it "returns success message" do
      expect(subject).to eq "-ERR Invalid parameter"
    end
  end
end
