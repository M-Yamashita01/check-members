# frozen_string_literal: true

require 'octokit'
require 'sawyer'
require 'spec_helper'

RSpec.describe GithubApiRequest do
  let(:github_api_base_url) { 'https://api.github.com' }
  let(:access_token) { 'Sample Access Token' }

  before do
    faraday = Faraday.new(github_api_base_url) do |conn|
      conn.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get(rest_domain_url) { [status_code, {}, body] }
      end
    end

    agent = Sawyer::Agent.new(
      github_api_base_url,
      {
        faraday: faraday,
        links_parser: Sawyer::LinkParsers::Simple.new
      }
    )

    allow_any_instance_of(Octokit::Connection).to receive(:agent).and_return(agent)
  end

  describe '#seats' do
    let(:access_token) { 'Sample Access Token' }
    let(:organization_name) { 'SampleOrganization' }
    let(:rest_domain_url) { "/orgs/#{organization_name}" }

    subject { described_class.new(access_token: access_token).seats(organization_name: organization_name) }

    context 'when get an organization' do
      let(:status_code) { 200 }
      let(:body) do
        {
          'plan': {
            'name': 'Medium',
            'space': 400,
            'private_repos': 20,
            'filled_seats': 4,
            'seats': 5
          }
        }
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

  describe '#exist_user?' do
    let(:username) { 'monalisa' }
    let(:rest_domain_url) { "/users/#{username}" }

    subject { described_class.new(access_token: access_token).exist_user?(username: username) }

    context 'when get an existed user' do
      let(:status_code) { 200 }
      let(:body) { '' }

      it { expect(subject).to be_truthy }
    end

    context 'when get a not existed user' do
      let(:status_code) { 404 }
      let(:body) { '' }

      it { expect(subject).to be_falsey }
    end
  end
end
