# frozen_string_literal: true

require 'octokit'
require 'sawyer'
require 'spec_helper'

RSpec.describe GitHubOrganization do
  describe '#seats' do
    let(:access_token) { 'Sample Access Token' }
    let(:organization_name) { 'SampleOrganization' }

    subject { described_class.new(access_token: access_token, organization_name: organization_name).seats }

    context 'when get an organization' do
      before do
        agent = Sawyer::Agent.new(
          'https://api.github.com',
          links_parser: Sawyer::LinkParsers::Simple.new
        )

        file = File.open("#{__dir__}/fixtures/organization.json")
        response = file.read
        hashed_response = JSON.parse(response)

        resource = Sawyer::Resource.new(agent, hashed_response)
        allow_any_instance_of(Octokit::Client).to receive(:org).and_return(resource)
      end

      it 'get filled_seats and max_seats' do
        seats = subject
        expect(seats[:filled_seats]).to eq(4)
        expect(seats[:max_seats]).to eq(5)
      end
    end

    context 'organization name is nil' do
      let(:organization_name) { nil }

      before do
        allow_any_instance_of(Octokit::Error).to receive(:build_error_message).and_return('not found')
        not_found_error = Octokit::NotFound.new('')
        allow_any_instance_of(Octokit::Client).to receive(:org).and_raise(not_found_error)
        allow_any_instance_of(Logger).to receive(:error).and_return('')
      end

      it 'raise error' do
        expect { subject }.to raise_error(Octokit::NotFound)
      end
    end
  end
end
