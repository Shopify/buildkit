# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'ostruct'

describe Buildkit::Error do
  context '.from_response' do
    it 'properly serializes an error from a 400 response' do
      error_obj = {
        errors: [
          {'field1' => 'cannot be empty'},
          {'field2' => 'must be a valid branch name'},
        ],
      }
      headers = {content_type: 'application/json'}
      response = stub_response(400, error_obj.to_json, headers)

      error = Buildkit::Error.from_response(response)
      expected_message = <<~MSG.chomp
        GET https://fake-buildkite-url.io/test?access_token=(redacted): 400 - Error summary:\n  field1: cannot be empty\n  field2: must be a valid branch name
      MSG

      expect(error).to be_kind_of(Buildkit::BadRequest)
      expect(error.message).to eq(expected_message)
    end

    it 'properly serializes an error from a 404 response' do
      response = stub_response(404, 'Not Found.')

      error = Buildkit::Error.from_response(response)
      expect(error).to be_kind_of(Buildkit::NotFound)
      expect(error.message).to eq('GET https://fake-buildkite-url.io/test?access_token=(redacted): 404 - Not Found.')
    end
  end

  private

  def stub_response(http_code, body, headers = {})
    OpenStruct.new(
      method: 'GET',
      url: 'https://fake-buildkite-url.io/test?access_token=123',
      status: http_code,
      body: body,
      response_headers: headers,
    )
  end
end
