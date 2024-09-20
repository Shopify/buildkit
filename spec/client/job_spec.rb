# frozen_string_literal: true

require 'spec_helper'

describe Buildkit::Client::Jobs do
  context '#retry_job' do
    it 'retry the failed job' do
      VCR.use_cassette 'retry_job' do
        job = client.retry_job('shopify', 'shopify-branches', 191_425, '7372c88b-320d-4a2e-bdf8-6e2fc9259fbe')
        expect(job.id).to be == '7372c88b-320d-4a2e-bdf8-6e2fc9259fbe'
        expect(job.state).to be == 'scheduled'
      end
    end
  end

  context '#job_env' do
    it 'get the env variables of the job' do
      VCR.use_cassette 'job_env' do
        job = client.job_env('shopify', 'shopify-branches', 191_425, '7372c88b-320d-4a2e-bdf8-6e2fc9259fbe')
        expect(job.env.BUILDBOX_JOB_ID).to be == '7372c88b-320d-4a2e-bdf8-6e2fc9259fbe'
        expect(job.env.BUILDKITE_RETRY_COUNT.to_i).to be == 3
      end
    end
  end

  context '#job_logs' do
    it 'get the log output of the job' do
      VCR.use_cassette 'job_log' do
        job = client.job_log('shopify', 'shopify-branches', 191_425, '7372c88b-320d-4a2e-bdf8-6e2fc9259fbe')
        expect(job.content).to be == 'log entry content'
        expect(job.size).to be == 17
      end
    end
  end

  context '#unblock' do
    it 'unblock the job' do
      VCR.use_cassette 'unblock a job' do
        job = client.unblock('xenor', 'demokite', 1, '01920d5c-ecf9-479b-89de-b746318d0fbe')
        expect(job.state).to be == 'unblocked'
      end
    end
  end
end
