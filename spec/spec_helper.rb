require 'vcr'

VCR.configure do |config|
  config.configure_rspec_metadata!
  config.cassette_library_dir = 'spec/cassettes/'
  config.hook_into :faraday
  config.filter_sensitive_data("<<ACCESS_TOKEN>>") do
    test_buildkite_token
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'buildkit'

module TestClient
  extend RSpec::SharedContext
  let(:client) { Buildkit::Client.new(token: test_buildkite_token) }
end

RSpec.configure do |config|
  config.include TestClient
end

def test_buildkite_token
  ENV.fetch 'BUILDKITE_TEST_TOKEN', 'x' * 40
end
