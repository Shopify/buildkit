require 'spec_helper'

describe Buildkit::Client::Pipelines do
  context '#pipelines' do
    it 'returns the list of pipelines' do
      VCR.use_cassette 'pipelines' do
        pipelines = client.pipelines('shopify', per_page: 2)
        expect(pipelines.size).to be == 2

        pipeline = pipelines.first
        expect(pipeline.name).to be == 'shopify-borgified'
      end
    end
  end

  context '#pipeline' do
    it 'returns the pipeline' do
      VCR.use_cassette 'pipeline' do
        pipeline = client.pipeline('shopify', 'shopify-borgified')
        expect(pipeline.name).to be == 'shopify-borgified'
      end
    end
  end
end
