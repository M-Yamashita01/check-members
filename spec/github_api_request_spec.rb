# frozen_string_literal: true

require 'octokit'
require 'sawyer'
require 'spec_helper'

RSpec.describe GithubApiRequest do
  describe '#seats' do
    let(:access_token) { 'Sample Access Token' }
    let(:organization_name) { 'SampleOrganization' }

    subject { described_class.new(access_token: access_token).seats(organization_name: organization_name) }

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

  describe '#exist_user?' do
    let(:github_rest_api_url) { 'https://api.github.com' }
    let(:access_token) { 'Sample Access Token' }
    let(:user_name) { 'monalisa' }

    before do
      faraday = Faraday.new(github_rest_api_url) do |conn|
        conn.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get("/users/#{user_name}") { [status_code, {}, body] }
        end
      end

      agent = Sawyer::Agent.new(
        github_rest_api_url,
        {
          faraday: faraday,
          links_parser: Sawyer::LinkParsers::Simple.new
        }
      )

      allow_any_instance_of(Octokit::Connection).to receive(:agent).and_return(agent)
    end

    subject { described_class.new(access_token: access_token).exist_user?(user_name: user_name) }

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
