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

    it 'returns all pipelines if all_pages is true' do
      VCR.use_cassette 'pipelines' do
        pipelines = client.pipelines('shopify', all_pages: true)
        expect(pipelines.size).to be == 3

        pipeline = pipelines.first
        expect(pipeline.name).to eq 'shopify-borgified'

        pipeline = pipelines.last
        expect(pipeline.name).to eq 'pipeline from the second page'
      end
    end

    it 'returns first page if all_pages is false' do
      VCR.use_cassette 'pipelines' do

        pipelines = client.pipelines('shopify')
        expect(pipelines.size).to be == 2

        pipeline = pipelines.first
        expect(pipeline.name).to eq 'shopify-borgified'

        pipeline = pipelines.last
        expect(pipeline.name).to eq 'Shopify for iPhone'
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

  context '#create_pipeline' do
    it 'creates a new pipeline' do
      VCR.use_cassette 'create_pipeline' do
        pipeline_params = {
          name: 'My pipeline',
          repository: 'git@github.com:acme/pipeline.git',
          steps: [
            {
              type: 'script',
              name: 'Build',
              command: 'script/build.sh',
            },
          ],
          timeout_in_minutes: 10,
          agent_query_rules: ['test=true'],
        }

        pipeline = client.create_pipeline('shopify', pipeline_params)
        expect(pipeline.slug).to be == 'my-pipeline'
      end
    end
  end

  context '#update_pipeline' do
    it 'update the pipeline' do
      VCR.use_cassette 'update_pipeline' do
        pipeline_params = {
          name: 'My pipeline 2',
        }
        pipeline = client.update_pipeline('shopify', 'my-pipeline', pipeline_params)
        expect(pipeline.name).to be == 'My pipeline 2'
        expect(pipeline.slug).to be == 'my-pipeline-2'
      end
    end
  end
end
