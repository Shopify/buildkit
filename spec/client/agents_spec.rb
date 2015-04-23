require 'spec_helper'

describe Buildkit::Client::Agents do
  context '#agents' do
    it 'returns the list of agents' do
      VCR.use_cassette 'agents' do
        agents = client.agents('shopify', per_page: 2)
        expect(agents.size).to be == 2

        agent = agents.first
        expect(agent.name).to be == 'a2.bk3.ec2.shopify.com'
        expect(agent.connection_state).to be == 'connected'
      end
    end
  end

  context '#agent' do
    it 'returns the agent' do
      VCR.use_cassette 'agent' do
        agent = client.agent('shopify', '60c64470-3930-4297-8a45-786e9bec3ea6')
        expect(agent.name).to be == 'a2.bk3.ec2.shopify.com'
        expect(agent.connection_state).to be == 'connected'
      end
    end
  end
end
