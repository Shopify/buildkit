# frozen_string_literal: true

require 'spec_helper'
require 'ostruct'

RSpec.describe 'Rate limit handling' do
  def stub_response(http_code, body = '', headers = {})
    {
      method: 'GET',
      url: 'https://example.com',
      status: http_code,
      body: body,
      response_headers: headers,
    }
  end

  context 'error mapping' do
    it 'maps 429 to RateLimitExceeded' do
      response = stub_response(429, 'Rate limit exceeded')
      error = Buildkit::Error.from_response(response)
      expect(error).to be_kind_of(Buildkit::RateLimitExceeded)
    end
  end

  context 'client auto retry' do
    it 'retries and succeeds when enabled' do
      client = Buildkit::Client.new(token: 'abc', auto_retry_rate_limit: true, rate_limit_retry_count: 2)

      # Build fake Sawyer agent
      agent = double('Sawyer::Agent')
      call_count = 0
      success_response = OpenStruct.new(data: 'ok')
      # First call raises rate limit, second succeeds
      allow(agent).to receive(:call) do |_method, _path, _data, _options|
        if (call_count += 1) == 1
          raise Buildkit::RateLimitExceeded.new(stub_response(429, '', { rate_limit_reset: '0' }))
        else
          success_response
        end
      end
      allow(client).to receive(:sawyer_agent).and_return(agent)
      allow(client).to receive(:sleep) # prevent actual wait

      result = client.send(:request, :get, '/path', {})
      expect(result).to eq('ok')
      expect(call_count).to eq(2)
    end

    it 'does not retry when disabled' do
      client = Buildkit::Client.new(token: 'abc', auto_retry_rate_limit: false)
      agent = double('Sawyer::Agent')
      allow(agent).to receive(:call).and_raise(Buildkit::RateLimitExceeded.new(stub_response(429)))
      allow(client).to receive(:sawyer_agent).and_return(agent)

      expect do
        client.send(:request, :get, '/path', {})
      end.to raise_error(Buildkit::RateLimitExceeded)
    end
  end
end
