# frozen_string_literal: true

module Buildkit
  # Custom error class for rescuing from all Buildkite errors
  class Error < StandardError
    # Returns the appropriate Buildkit::Error subclass based
    # on status and response message
    #
    # @param [Hash] response HTTP response
    # @return [Buildkit::Error]
    def self.from_response(response)
      status = response[:status].to_i
      if klass =  case status
                  when 400      then Buildkit::BadRequest
                  when 401      then Buildkit::Unauthorized
                  when 403      then Buildkit::Forbidden
                  when 404      then Buildkit::NotFound
                  when 405      then Buildkit::MethodNotAllowed
                  when 406      then Buildkit::NotAcceptable
                  when 409      then Buildkit::Conflict
                  when 415      then Buildkit::UnsupportedMediaType
                  when 422      then Buildkit::UnprocessableEntity
                  when 400..499 then Buildkit::ClientError
                  when 500      then Buildkit::InternalServerError
                  when 501      then Buildkit::NotImplemented
                  when 502      then Buildkit::BadGateway
                  when 503      then Buildkit::ServiceUnavailable
                  when 500..599 then Buildkit::ServerError
                  end
        klass.new(response)
      end
    end

    def initialize(response = nil)
      @response = response
      super(build_error_message)
    end

    # Documentation URL returned by the API for some errors
    #
    # @return [String]
    def documentation_url
      data[:documentation_url] if data.is_a? Hash
    end

    # Array of validation errors
    # @return [Array<Hash>] Error info
    def errors
      if data&.is_a?(Hash)
        data[:errors] || []
      else
        []
      end
    end

    private

    def data
      @data ||= parse_data
    end

    def parse_data
      body = @response[:body]
      return if body.empty?
      return body unless body.is_a?(String)

      headers = @response[:response_headers]
      content_type = headers && headers[:content_type] || ''
      if content_type =~ /json/
        Sawyer::Agent.serializer.decode(body)
      else
        body
      end
    end

    def response_message
      case data
      when Hash
        data[:message]
      when String
        data
      end
    end

    def response_error
      "Error: #{data[:error]}" if data.is_a?(Hash) && data[:error]
    end

    def response_error_summary
      return nil unless data.is_a?(Hash) && !Array(data[:errors]).empty?

      errors = data[:errors].map do |hash|
        hash.map { |k, v| "  #{k}: #{v}" }
      end

      <<~MSG.chomp
        Error summary:
        #{errors.join("\n")}
      MSG
    end

    def build_error_message
      return nil if @response.nil?

      documentation_text = ''
      documentation_text = "// See: #{documentation_url}" if documentation_url

      <<~MSG.strip
        #{@response[:method].to_s.upcase} #{redact_url(@response[:url].to_s)}: #{@response[:status]} - #{response_message}#{response_error}#{response_error_summary}
        #{documentation_text}
      MSG
    end

    def redact_url(url_string)
      %w[client_secret access_token].each do |token|
        url_string = url_string.gsub(/#{token}=\S+/, "#{token}=(redacted)") if url_string.include? token
      end
      url_string
    end
  end

  # Raised on errors in the 400-499 range
  class ClientError < Error; end

  # Raised when Buildkite returns a 400 HTTP status code
  class BadRequest < ClientError; end

  # Raised when Buildkite returns a 401 HTTP status code
  class Unauthorized < ClientError; end

  # Raised when Buildkite returns a 403 HTTP status code
  class Forbidden < ClientError; end

  # Raised when Buildkite returns a 404 HTTP status code
  class NotFound < ClientError; end

  # Raised when Buildkite returns a 405 HTTP status code
  class MethodNotAllowed < ClientError; end

  # Raised when Buildkite returns a 406 HTTP status code
  class NotAcceptable < ClientError; end

  # Raised when Buildkite returns a 409 HTTP status code
  class Conflict < ClientError; end

  # Raised when Buildkite returns a 414 HTTP status code
  class UnsupportedMediaType < ClientError; end

  # Raised when Buildkite returns a 422 HTTP status code
  class UnprocessableEntity < ClientError; end

  # Raised on errors in the 500-599 range
  class ServerError < Error; end

  # Raised when Buildkite returns a 500 HTTP status code
  class InternalServerError < ServerError; end

  # Raised when Buildkite returns a 501 HTTP status code
  class NotImplemented < ServerError; end

  # Raised when Buildkite returns a 502 HTTP status code
  class BadGateway < ServerError; end

  # Raised when Buildkite returns a 503 HTTP status code
  class ServiceUnavailable < ServerError; end

  # Raised when client fails to provide valid Content-Type
  class MissingContentType < ArgumentError; end
end
