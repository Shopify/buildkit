# frozen_string_literal: true

require 'spec_helper'

describe Buildkit::Client::Artifacts do
  context '#artifacts' do
    it 'returns the list of artifacts' do
      VCR.use_cassette 'artifacts' do
        artifacts = client.artifacts('shopify', 'shopify-branches', 219_190, per_page: 2)
        expect(artifacts.size).to be == 2

        artifact = artifacts.first
        expect(artifact.state).to be == 'finished'
        expect(artifact.path).to be == 'lhm.log'
      end
    end
  end

  context '#job_artifacts' do
    it 'returns the list of artifacts' do
      VCR.use_cassette 'job_artifacts' do
        job_id = 'aacb3091-2d24-4016-8d57-a1187a381a5b'
        artifacts = client.job_artifacts('shopify', 'shopify-master-rotoscope', 473, job_id, per_page: 2)
        expect(artifacts.size).to be == 2

        artifact = artifacts.first
        expect(artifact.state).to be == 'finished'
        expect(artifact.path).to be == 'lhm.log'
      end
    end
  end
end
