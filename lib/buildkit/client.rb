require 'sawyer'
require 'buildkit/client/agents'
require 'buildkit/client/builds'
require 'buildkit/client/organizations'
require 'buildkit/client/pipelines'
require 'buildkit/client/jobs'
require 'buildkit/client/artifacts'
require 'buildkit/response/raise_error'

module Buildkit
  class Client
    include Agents
    include Builds
    include Organizations
    include Pipelines
    include Jobs
    include Artifacts

    DEFAULT_ENDPOINT = 'https://api.buildkite.com/v2/'.freeze

    # Header keys that can be passed in options hash to {#get},{#head}
    CONVENIENCE_HEADERS = Set.new(%i[accept content_type])

    # In Faraday 0.9, Faraday::Builder was renamed to Faraday::RackBuilder
    RACK_BUILDER_CLASS = defined?(Faraday::RackBuilder) ? Faraday::RackBuilder : Faraday::Builder

    class << self
      def build_middleware
        RACK_BUILDER_CLASS.new do |builder|
          builder.use Buildkit::Response::RaiseError
          builder.adapter Faraday.default_adapter
          yield builder if block_given?
        end
      end
    end

    def initialize(endpoint: ENV.fetch('BUILDKITE_API_ENDPOINT', DEFAULT_ENDPOINT),
                   token: ENV.fetch('BUILDKITE_API_TOKEN'),
                   middleware: self.class.build_middleware)
      @middleware = middleware
      @endpoint = endpoint
      @token = token
    end

    # Make a HTTP GET request
    #
    # @param url [String] The path, relative to {@endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def get(url, options = {})
      if options.delete(:all_pages)
        request_all_pages :get, url, parse_query_and_convenience_headers(options)
      else
        request(:get, url, parse_query_and_convenience_headers(options)).data
      end
    end

    # Make a HTTP POST request
    #
    # @param url [String] The path, relative to {@endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def post(url, options = {})
      request(:post, url, options).data
    end

    # Make a HTTP PUT request
    #
    # @param url [String] The path, relative to {@endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def put(url, options = {})
      request(:put, url, options).data
    end

    # Make a HTTP PATCH request
    #
    # @param url [String] The path, relative to {@endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def patch(url, options = {})
      request(:patch, url, options).data
    end

    # Make a HTTP DELETE request
    #
    # @param url [String] The path, relative to {@endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def delete(url, options = {})
      request(:delete, url, options).data
    end

    # Make a HTTP HEAD request
    #
    # @param url [String] The path, relative to {@endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def head(url, options = {})
      request(:head, url, parse_query_and_convenience_headers(options)).data
    end

    # Fetch the root resource for the API
    #
    # @return [Sawyer::Resource]
    def root
      get('/')
    end

    private

    def request(method, path, data, options = {})
      if data.is_a?(Hash)
        options = extract_query_and_headers_from data
        if accept = data.delete(:accept)
          options[:headers][:accept] = accept
        end
      end

      response = sawyer_agent.call(method, URI::Parser.new.escape(path.to_s), data, options)
      response
    end

    def extract_query_and_headers_from(data)
      {
        query: data.delete(:query) || {},
        headers: data.delete(:headers) || {},
      }
    end

    def request_all_pages(method, path, data, options = {})
      response = []
      loop do
        res = request(method, path, data, options)
        link_header = parse_link_header(res.headers[:link])
        res.data.each { |r| response << r }
        break if link_header.nil? || link_header[:next].nil?
        path = next_page(link_header[:next]) if link_header[:next]
      end
      response
    end

    def next_page(next_page)
      return build_path URI(next_page) unless next_page.nil?
      nil
    end

    def build_path(uri)
      "#{uri.path}?#{uri.query}"
    end

    def sawyer_agent
      @sawyer_agent ||= Sawyer::Agent.new(@endpoint, sawyer_options) do |http|
        http.headers[:accept] = 'application/json'
        http.headers[:content_type] = 'application/json'
        http.headers[:user_agent] = "Buildkit v#{Buildkit::VERSION}"
        http.authorization 'Bearer', @token
      end
    end

    def sawyer_options
      {
        links_parser: Sawyer::LinkParsers::Simple.new,
        faraday: Faraday.new(builder: @middleware),
      }
    end

    def parse_link_header(link_header)
      return unless link_header
      links = {}
      link_header.split(',').each do |link|
        links = links.merge(parse_link(link))
      end
      links
    end

    def parse_link(link)
      section = link.split(';')
      url = parse_url section[0]
      name = parse_url_name section[1]
      {name => url}
    end

    def parse_url(url)
      url[/<(.+)>/, 1]
    end

    def parse_url_name(name)
      name[/rel="(.*)"/, 1].to_sym
    end

    def parse_query_and_convenience_headers(options)
      headers = options.fetch(:headers, {})
      CONVENIENCE_HEADERS.each do |h|
        if header = options.delete(h)
          headers[h] = header
        end
      end
      query = options.delete(:query)
      opts = {query: options}
      opts[:query].merge!(query) if query && query.is_a?(Hash)
      opts[:headers] = headers unless headers.empty?

      opts
    end
  end
end
