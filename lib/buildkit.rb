# frozen_string_literal: true

require 'buildkit/version'
require 'buildkit/client'

module Buildkit
  def self.new(*args, **kwargs)
    Client.new(**kwargs)
  end
end
