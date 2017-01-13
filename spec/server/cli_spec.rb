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

    socket.puts("PASS romek")
    expect(socket.gets).to eq "+OK maildrop locked and ready\n"

    socket.puts("STAT")
    expect(socket.gets).to eq "+OK 2 320\n"

    socket.puts("LIST 1")
    expect(socket.gets).to eq "+OK 1 102\n"

    socket.puts("DELE 1")
    expect(socket.gets).to eq "+OK Message deleted\n"

    socket.puts("RSET")
    expect(socket.gets).to eq "+OK maildrop has 2 messages (320 octets)\n"

    socket.puts("QUIT")
    expect(socket.gets).to eq "+OK dewey POP3 localhost v0.1.0 server signing off\n"

    socket.close
  end
end
