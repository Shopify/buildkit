# frozen_string_literal: true

module Buildkit
  class Client
    # Methods for the Builds API
    #
    # Identifier arguments must be single URL path segments; see {Buildkit::InvalidRouteSegment}.
    #
    # @see https://buildkite.com/docs/api/builds
    module Builds
      # List all builds
      #
      # @return [Array<Sawyer::Resource>] Array of hashes representing Buildkite builds.
      # @see https://buildkite.com/docs/api/builds#list-all-builds
      # @example
      #   Buildkit.builds
      def builds(options = {})
        get('/v2/builds', options)
      end

      # List builds for an organization
      #
      # @param org [String] Organization slug.
      # @return [Array<Sawyer::Resource>] Array of hashes representing Buildkite builds.
      # @see https://buildkite.com/docs/api/builds#list-builds-for-an-organization
      # @example
      #   Buildkit.organization_builds('my-great-org'))
      def organization_builds(org, options = {})
        get("/v2/organizations/#{route_segment(org, :org)}/builds", options)
      end

      # List builds for a pipeline
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] pipeline slug.
      # @return [Array<Sawyer::Resource>] Array of hashes representing Buildkite builds.
      # @see https://buildkite.com/docs/api/builds#list-builds-for-a-pipeline
      # @example
      #   Buildkit.pipeline_builds('my-great-org', 'great-pipeline')
      def pipeline_builds(org, pipeline, options = {})
        get(builds_path(org, pipeline), options)
      end

      # Get a build
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] pipeline slug.
      # @param number [Integer] Build number.
      # @return [Sawyer::Resource] Hash representing Buildkite build.
      # @see https://buildkite.com/docs/api/builds#get-a-build
      # @example
      #   Buildkit.build('my-great-org', 'great-pipeline', 42)
      def build(org, pipeline, number, options = {})
        get("#{builds_path(org, pipeline)}/#{route_segment(number, :number)}", options)
      end

      # Rebuild a build
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] pipeline slug.
      # @param number [Integer] Build number.
      # @see https://buildkite.com/docs/api/builds#rebuild-a-build
      # @example
      #   Buildkit.rebuild('my-great-org', 'great-pipeline', 42)
      def rebuild(org, pipeline, number, options = {})
        put("#{builds_path(org, pipeline)}/#{route_segment(number, :number)}/rebuild", options)
      end

      # Create a build
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] pipeline slug.
      # @see https://buildkite.com/docs/api/builds#create-a-build
      # @example
      #   Buildkit.create_build('my-great-org', 'great-pipeline', {
      #     commit: 'HEAD',
      #     branch: 'master',
      #     message: 'Hello, world!',
      #     author: {
      #       name: 'Liam Neeson',
      #       email: 'liam@evilbatmanvillans.com'
      #     }
      #   })
      #
      def create_build(org, pipeline, options = {})
        post(builds_path(org, pipeline), options)
      end

      # Cancel a build
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] pipeline slug.
      # @param number [Integer] Build number.
      # @see https://buildkite.com/docs/rest-api/builds#cancel-a-build
      # @example
      #   Buildkit.cancel_build('my-great-org', 'great-pipeline', 42)
      def cancel_build(org, pipeline, number, options = {})
        put("#{builds_path(org, pipeline)}/#{route_segment(number, :number)}/cancel", options)
      end

      private

      def builds_path(org, pipeline)
        "/v2/organizations/#{route_segment(org, :org)}/pipelines/#{route_segment(pipeline, :pipeline)}/builds"
      end
    end
  end
end
