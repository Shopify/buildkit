module Buildkit
  class Client
    # Methods for the Artifacts API
    #
    # @see https://buildkite.com/docs/api/artifacts
    module Artifacts
      # List artifacts
      #
      # @return [Array<Sawyer::Resource>] Array of hashes representing Buildkite artifacts.
      # @see https://buildkite.com/docs/api/artifacts#list-artifacts-for-a-build
      # @see https://buildkite.com/docs/api/artifacts#list-artifacts-for-a-job
      # @example
      #   Buildkit.artifacts('my-great-org', 'my-pipeline', 'my-build')
      #   Buildkit.artifacts('my-great-org', 'my-pipeline', 'my-build', job: 'my-job')
      def artifacts(org, pipeline, build, options = {})
        base_url = "/v1/organizations/#{org}/pipelines/#{pipeline}/builds/#{build}"
        base_url << "/jobs/#{options[:job]}" unless options[:job].nil?
        get("#{base_url}/artifacts", options)
      end

      # Get an artifact
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] Pipeline slug.
      # @param build [String] Build id.
      # @param id [String] Artifact id.
      # @return [Sawyer::Resource] Hash representing Buildkite artifact
      # @see https://buildkite.com/docs/api/artifacts#get-an-artifact
      # @example
      #   Buildkit.artifact('my-great-org', 'my-pipeline', '0b461f65-e7be-4c80-888a-ef11d81fd971')
      def artifact(org, pipeline, build, job_id, id, options = {})
        url = "/v1/organizations/#{org}/pipelines/#{pipeline}/builds/#{build}/jobs/#{job_id}/artifacts/#{id}"
        get(url, options)
      end

      # Download an artifact
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] Pipeline slug.
      # @param build [String] Build id.
      # @param id [String] Artifact id.
      # @return [Sawyer::Resource] Hash with URL to download artifact, valid for 60s
      # @see https://buildkite.com/docs/api/artifacts#download-an-artifact
      # @example
      #   Buildkit.download_artifact('my-great-org', 'my-pipeline', '0b461f65-e7be-4c80-888a-ef11d81fd971')
      def download_artifact(org, pipeline, build, job_id, id, options = {})
        url = "/v1/organizations/#{org}/pipelines/#{pipeline}/builds/#{build}/jobs/#{job_id}/artifacts/#{id}/download"
        get(url, options)
      end
    end
  end
end
