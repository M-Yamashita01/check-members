# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CheckMembersAction do
  subject { described_class.new.run }

  let(:octokit_client) { instance_double(Octokit::Client) }
  let(:kernel) { instance_double(Kernel) }

  describe '#run' do
    before do
      ENV['ACCESS_TOKEN'] = 'Sample Access Token'
      ENV['TERRAFORM_JSON_FILE_PATH'] = "#{__dir__}/fixtures/terraform_valid_json.json"
      ENV['ORGANIZATION_NAME'] = 'organization-test'
      ENV['INPUT_VERIFY_EXISTENCE_ACCOUNT'] = 'true'

      agent = Sawyer::Agent.new(
        'https://api.github.com',
        links_parser: Sawyer::LinkParsers::Simple.new
      )

      file = File.open("#{__dir__}/fixtures/organization.json")
      response = file.read
      hashed_response = JSON.parse(response)

      resource = Sawyer::Resource.new(agent, hashed_response)
      allow_any_instance_of(Octokit::Client).to receive(:org).and_return(resource)
      allow_any_instance_of(GithubApiRequest).to receive(:exist_user?).and_return(false)
      allow_any_instance_of(Kernel).to receive(:exit).and_return(true)
    end

    it 'this action calls exit method with no arguments.' do
      expect_any_instance_of(Kernel).to receive(:exit).with(no_args).once

      subject
    end
  end
end
