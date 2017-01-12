require 'spec_helper'

describe Server::Connection do
  context 'handshake' do
    subject { described_class.new.handshake }

    it { is_expected.to eq '+OK POP3 localhost v0.1.0 server ready' }
  end
end
