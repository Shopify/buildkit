require 'spec_helper'

describe Buildkit::Client::Organizations do
  context '#organizations' do
    it 'returns the list of organizations' do
      VCR.use_cassette 'organizations' do
        organizations = client.organizations
        expect(organizations.size).to be == 1

        organization = organizations.first
        expect(organization.name).to be == 'Shopify'
        expect(organization.slug).to be == 'shopify'
      end
    end
  end

  context '#organization' do
    it 'returns an organization' do
      VCR.use_cassette 'organization' do
        organization = client.organization('shopify')
        expect(organization.name).to be == 'Shopify'
        expect(organization.slug).to be == 'shopify'
      end
    end
  end
end
