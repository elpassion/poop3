require "spec_helper"

describe Server do
  it "has a version number" do
    expect(Server::VERSION).not_to be nil
  end
end
