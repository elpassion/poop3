require 'spec_helper'

describe Server::Cli do
  before do
    Thread.abort_on_exception = true
    @serverThread = Thread.new { Server::Cli.run }
  end

  after do
    Thread.kill @serverThread
  end

  it 'sends handshake' do
    socket = TCPSocket.new 'localhost', 1100
    expect(socket.gets).to eq "+OK POP3 localhost v0.1.0 server ready\n"

    socket.puts("USER romek")
    expect(socket.gets).to eq "+OK User accepted, password please\n"

    socket.close
  end
end
