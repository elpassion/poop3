require 'spec_helper'

describe Server::MessageHandler, "DELE command" do

  subject { described_class.new(command).call }

  context "with valid parameter" do
    let(:command) { "CAPA" }

    it "returns success message" do
      expect(subject).to eq "+OK Capability list follows\r\n" +
        "CAPA\r\n" + 
        "DELE\r\n" + 
        "LIST\r\n" + 
        "NOOP\r\n" + 
        "PASS\r\n" + 
        "QUIT\r\n" + 
        "RETR\r\n" + 
        "USER\r\n" + 
        "STAT\r\n" + 
        "RSET\r\n" +
        "."
  end
end
end
