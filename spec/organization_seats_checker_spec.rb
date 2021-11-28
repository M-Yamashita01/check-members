# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OrganizationSeatsChecker do
  subject { described_class.new.run }

  describe '#run' do
    before do
      ENV['GITHUB_PERSONAL_ACCESS_TOKEN'] = 'Sample Access Token'
      ENV['MEMBERSHIP_FILE_PATH'] = "#{__dir__}/fixtures/membership.tf"
      ENV['REPOSITORY_COLLABORATOR_FILE_PATH'] = "#{__dir__}/fixtures/repository_collaborator.tf"
      ENV['ORGANIZATION_NAME'] = 'rganization-test'

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

    it 'get seats and member counts' do
      actual = <<~TEXT
        ::set-output name=filled_seats::4
        ::set-output name=seats::5
        ::set-output name=member_count::7
      TEXT

      expect { subject }.to output(actual).to_stdout
    end
  end
end
