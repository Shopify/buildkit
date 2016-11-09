module Buildkit
  class Client
    # Methods for the Organizations API
    #
    # @see https://buildkite.com/docs/api/organizations
    module Organizations
      # List organizations
      #
      # @return [Array<Sawyer::Resource>] Array of hashes representing Buildkite organizations.
      # @see https://buildkite.com/docs/api/organizations#list-organizations
      # @example
      #   Buildkit.organizations
      def organizations(options = {})
        get('/v2/organizations', options)
      end

      # Get an organization
      #
      # @param org [String] Organization slug.
      # @return [Sawyer::Resource] Hash representing Buildkite organization.
      # @see https://buildkite.com/docs/api/organizations#get-an-organization
      # @example
      #   Buildkit.organization('my-great-org')
      def organization(org, options = {})
        get("/v2/organizations/#{org}", options)
      end
    end
  end
end
