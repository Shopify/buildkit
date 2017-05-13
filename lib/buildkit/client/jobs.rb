module Buildkit
  class Client
    # Methods for the Jobs API
    #
    # @see https://buildkite.com/docs/rest-api/jobs
    module Jobs
      # Retry a job
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] Pipeline slug.
      # @param build [Integer] Build number.
      # @param job [String] Job id.
      # @return [Array<Sawyer::Resource>] Hashes representing Buildkite job.
      # @see https://buildkite.com/docs/rest-api/jobs#retry-a-job
      # @example
      #   Buildkit.retry_job('my-great-org', 'great-pipeline', 123, 'my-job-id')
      def retry_job(org, pipeline, build, job, options = {})
        put("/v2/organizations/#{org}/pipelines/#{pipeline}/builds/#{build}/jobs/#{job}/retry", options)
      end

      # Get a job's environment variables
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] Pipeline slug.
      # @param build [Integer] Build number.
      # @param job [String] Job id.
      # @return [Array<Sawyer::Resource>] Hashes representing Buildkite job env.
      # @see https://buildkite.com/docs/rest-api/jobs#get-a-jobs-environment-variables
      # @example
      #   Buildkit.job_env('my-great-org', 'great-pipeline', 123, 'my-job-id')
      def job_env(org, pipeline, build, job, options = {})
        get("/v2/organizations/#{org}/pipelines/#{pipeline}/builds/#{build}/jobs/#{job}/env", options)
      end

      # Get a job's log output
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] Pipeline slug.
      # @param build [Integer] Build number.
      # @param job [String] Job id.
      # @return [Sawyer::Resource] Hash representing the Buildkit job log output.
      # @see https://buildkite.com/docs/rest-api/jobs#get-a-jobs-log-output
      # @example
      #   Buildkit.job_log('my-great-org', 'great-pipeline', 123, 'my-job-id')
      def job_log(org, pipeline, build, job, options = {})
        get("/v2/organizations/#{org}/pipelines/#{pipeline}/builds/#{build}/jobs/#{job}/log", options)
      end
    end
  end
end
