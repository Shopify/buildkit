# frozen_string_literal: true

require 'faraday'
require 'buildkit/error'

module Buildkit
  # Faraday response middleware
  module Response
    # This class raises an Buildkit-flavored exception based
    # HTTP status codes returned by the API
    class RaiseError < Faraday::Response::Middleware
      def on_complete(response)
        if error = Buildkit::Error.from_response(response)
          raise error
        end
      end
    end
  end
end
