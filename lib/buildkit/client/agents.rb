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
        get("/v2/organizations/#{org}/agents", options)
      end

      # Get an agent
      #
      # @param org [String] Organization slug.
      # @param id [String] Agent id.
      # @return [Sawyer::Resource] Hash representing Buildkite agent
      # @see https://buildkite.com/docs/api/agents#get-an-agent
      # @example
      #   Buildkit.agent('my-great-org', '0b461f65-e7be-4c80-888a-ef11d81fd971')
      def agent(org, id, options = {})
        get("/v2/organizations/#{org}/agents/#{id}", options)
      end

      # Stop an agent
      #
      # @param org [String] Organization slug.
      # @param id [String] Agent id.
      # @see https://buildkite.com/docs/api/agents#stop-an-agent
      # @example Stop an  agent
      #   Buildkit.stop_agent('my-great-org', '16940c91-f12d-4122-8154-0edf6c0978c2')
      def stop_agent(org, id, options = {})
        put("/v2/organizations/#{org}/agents/#{id}/stop", options)
      end
    end
  end
end
