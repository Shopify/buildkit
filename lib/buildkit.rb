require 'buildkit/version'
require 'buildkit/client'

module Buildkit
  def self.new(*args)
    Client.new(*args)
  end
end
