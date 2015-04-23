require 'spec_helper'

describe Buildkit::Client::Projects do
  context '#projects' do
    it 'returns the list of projects' do
      VCR.use_cassette 'projects' do
        projects = client.projects('shopify', per_page: 2)
        expect(projects.size).to be == 2

        project = projects.first
        expect(project.name).to be == 'shopify-borgified'
      end
    end
  end

  context '#project' do
    it 'returns the project' do
      VCR.use_cassette 'project' do
        project = client.project('shopify', 'shopify-borgified')
        expect(project.name).to be == 'shopify-borgified'
      end
    end
  end
end
