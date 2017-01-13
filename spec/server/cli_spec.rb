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
    expect(socket.gets).to eq "+OK POP3 localhost v0.1.0 server ready\r\n"

    socket.puts("USER romek")
    expect(socket.gets).to eq "+OK User accepted, password please\r\n"

    socket.puts("PASS romek")
    expect(socket.gets).to eq "+OK maildrop locked and ready\r\n"

    socket.puts("STAT")
    expect(socket.gets).to eq "+OK 2 168\r\n"

    socket.puts("LIST 1")
    expect(socket.gets).to eq "+OK 1 84\r\n"

    socket.puts("DELE 1")
    expect(socket.gets).to eq "+OK Message deleted\r\n"

    socket.puts("RSET")
    expect(socket.gets).to eq "+OK maildrop has 2 messages (168 octets)\r\n"

    socket.puts("QUIT")
    expect(socket.gets).to eq "+OK dewey POP3 localhost v0.1.0 server signing off\r\n"

    socket.close
  end
end
