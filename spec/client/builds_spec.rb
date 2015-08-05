require 'spec_helper'

describe Buildkit::Client::Builds do
  context '#builds' do
    it 'returns the list of builds' do
      VCR.use_cassette 'builds' do
        builds = client.builds(per_page: 2)
        expect(builds.size).to be == 2

        build = builds.first
        expect(build.number).to be == 68
        expect(build.state).to be == 'failed'
      end
    end
  end

  context '#organization_builds' do
    it 'returns the list of builds' do
      VCR.use_cassette 'organization_builds' do
        builds = client.organization_builds('shopify', per_page: 2)
        expect(builds.size).to be == 2

        build = builds.first
        expect(build.number).to be == 68
        expect(build.state).to be == 'failed'
      end
    end
  end

  context '#project_builds' do
    it 'returns the list of builds' do
      VCR.use_cassette 'project_builds' do
        builds = client.project_builds('shopify', 'shopify-borgified', per_page: 2)
        expect(builds.size).to be == 2

        build = builds.first
        expect(build.number).to be == 68
        expect(build.state).to be == 'failed'
      end
    end
  end

  context '#build' do
    it 'returns the build' do
      VCR.use_cassette 'build' do
        build = client.build('shopify', 'shopify-borgified', 68)
        expect(build.number).to be == 68
        expect(build.state).to be == 'failed'
      end
    end
  end

  context '#rebuild' do
    it 'rebuilds the build' do
      VCR.use_cassette 'rebuild' do
        build = client.rebuild('shopify', 'shopify-borgified', 68)
        expect(build.state).to be == 'scheduled'
      end
    end
  end
end
