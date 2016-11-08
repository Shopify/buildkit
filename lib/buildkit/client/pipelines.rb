module Buildkit
  class Client
    # Methods for the pipelines API
    #
    # @see https://buildkite.com/docs/api/pipelines
    module Pipelines
      # List pipelines
      #
      # @return [Array<Sawyer::Resource>] Array of hashes representing Buildkite pipelines.
      # @see https://buildkite.com/docs/api/pipelines#list-pipelines
      # @example
      #   Buildkit.pipelines('my-great-org')
      def pipelines(org, options = {})
        get("/v2/organizations/#{org}/pipelines", options)
      end

      # Get a pipeline
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] pipeline slug.
      # @return [Sawyer::Resource] Hash representing Buildkite pipeline
      # @see https://buildkite.com/docs/api/pipelines#get-a-pipeline
      # @example
      #   Buildkit.pipeline('my-great-org', 'great-pipeline')
      def pipeline(org, pipeline, options = {})
        get("/v2/organizations/#{org}/pipelines/#{pipeline}", options)
      end

      # Create a pipeline
      #
      # @param org [String] Organization slug.
      # @see https://buildkite.com/docs/api/pipelines#create-a-pipeline
      # @example
      #   Buildkit.create_build('my-great-org', {
      #     name: 'My pipeline',
      #     repository: 'git@github.com:acme/pipeline.git',
      #     steps: [
      #       {
      #         type: 'script',
      #         name: 'Build',
      #         command: 'script/build.sh'
      #       }
      #     ],
      #     timeout_in_minutes: 10,
      #     agent_query_rules: ['test=true']
      #   })
      #
      def create_pipeline(org, options = {})
        post("/v2/organizations/#{org}/pipelines", options)
      end
    end
  end
end
