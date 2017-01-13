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
end
