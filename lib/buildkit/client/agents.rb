module Buildkit
  class Client
    # Methods for the Agents API
    #
    # @see https://buildkite.com/docs/api/agents
    module Agents
      # List agents
      #
      # @return [Array<Sawyer::Resource>] Array of hashes representing Buildkite agents.
      # @see https://buildkite.com/docs/api/agents#list-agents
      # @example
      #   Buildkit.agents('my-great-org')
      def agents(org, options = {})
        get("/v1/organizations/#{org}/agents", options)
      end

      # Get an organization
      #
      # @param org [String] Organization slug.
      # @param id [String] Agent id.
      # @return [Sawyer::Resource] Hash representing Buildkite agent
      # @see https://buildkite.com/docs/api/agents#get-an-agent
      # @example
      #   Buildkit.agent('my-great-org', '0b461f65-e7be-4c80-888a-ef11d81fd971')
      def agent(org, id, options = {})
        get("/v1/organizations/#{org}/agents/#{id}", options)
      end
    end
  end
end
