module Buildkit
  class Client
    # Methods for the Artifacts API
    #
    # @see https://buildkite.com/docs/api/artifacts
    module Artifacts
      # List all artifacts for a build
      #
      # @return [Array<Sawyer::Resource>] Array of hashes representing Buildkite artifacts.
      # @see https://buildkite.com/docs/api/artifacts#list-all-artifacts
      # @example
      #   Buildkit.artifacts('my-great-org', 'great-pipeline', 42)
      def artifacts(org, pipeline, build, options = {})
        get("/v2/organizations/#{org}/pipelines/#{pipeline}/builds/#{build}/artifacts", options)
      end

      # List all artifacts for a job
      #
      # @return [Array<Sawyer::Resource>] Array of hashes representing Buildkite artifacts.
      # @see https://buildkite.com/docs/rest-api/artifacts#list-artifacts-for-a-job
      # @example
      #   Buildkit.job_artifacts('my-great-org', 'great-pipeline', 42, '76365070-34d5-4104-8b91-952780f8029f')
      def job_artifacts(org, pipeline, build, job, options = {})
        get("/v2/organizations/#{org}/pipelines/#{pipeline}/builds/#{build}/jobs/#{job}/artifacts", options)
      end
    end
  end
end
