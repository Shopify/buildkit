# frozen_string_literal: true

require 'buildkit/version'
require 'buildkit/client'

module Buildkit
  class << self
    def new(*args)
      Client.new(*args)
    end
    ruby2_keywords :new if respond_to?(:ruby2_keywords, true)
  end
end
