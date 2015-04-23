module Buildkit
  class Client
    # Methods for the Projects API
    #
    # @see https://buildkite.com/docs/api/projects
    module Projects
      # List projects
      #
      # @return [Array<Sawyer::Resource>] Array of hashes representing Buildkite projects.
      # @see https://buildkite.com/docs/api/projects#list-projects
      # @example
      #   Buildkit.projects('my-great-org')
      def projects(org, options = {})
        get("/v1/organizations/#{org}/projects", options)
      end

      # Get a project
      #
      # @param org [String] Organization slug.
      # @param project [String] Project slug.
      # @return [Sawyer::Resource] Hash representing Buildkite project
      # @see https://buildkite.com/docs/api/projects#get-a-project
      # @example
      #   Buildkit.project('my-great-org', 'great-project')
      def project(org, project, options = {})
        get("/v1/organizations/#{org}/projects/#{project}", options)
      end
    end
  end
end
