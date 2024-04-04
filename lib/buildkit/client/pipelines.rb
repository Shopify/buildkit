# frozen_string_literal: true

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
      #   Buildkit.create_pipeline('my-great-org', {
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

      # Update a pipeline
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] pipeline slug.
      # @return [Sawyer::Resource] Hash representing Buildkite pipeline
      # @see https://buildkite.com/docs/api/pipelines#update-a-pipeline
      # @example
      #   Buildkit.update_pipeline('my-great-org', 'great-pipeline', {
      #     name: 'My pipeline 2',
      #   })
      #
      def update_pipeline(org, pipeline, options = {})
        patch("/v2/organizations/#{org}/pipelines/#{pipeline}", options)
      end

      # Archive a pipeline
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] pipeline slug.
      # @return [Sawyer::Resource] Hash representing Buildkite pipeline
      # @see https://buildkite.com/docs/api/pipelines#archive-a-pipeline
      # @example
      #   Buildkit.archive_pipeline('my-great-org', 'great-pipeline')
      #
      def archive_pipeline(org, pipeline)
        post("/v2/organizations/#{org}/pipelines/#{pipeline}/archive")
      end

      # Unarchive a pipeline
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] pipeline slug.
      # @return [Sawyer::Resource] Hash representing Buildkite pipeline
      # @see https://buildkite.com/docs/api/pipelines#unarchive-a-pipeline
      # @example
      #   Buildkit.unarchive_pipeline('my-great-org', 'great-pipeline')
      #
      def unarchive_pipeline(org, pipeline)
        post("/v2/organizations/#{org}/pipelines/#{pipeline}/unarchive")
      end

      # Delete a pipeline
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] pipeline slug.
      # @see https://buildkite.com/docs/apis/rest-api/pipelines#delete-a-pipeline
      # @example
      #   Buildkit.delete_pipeline('my-great-org', 'great-pipeline')
      #
      def delete_pipeline(org, pipeline)
        delete("/v2/organizations/#{org}/pipelines/#{pipeline}")
      end
    end
  end
end
