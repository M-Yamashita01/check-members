# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CheckMembersAction do
  let(:octokit_client) { instance_double(Octokit::Client) }
  let(:kernel) { instance_double(Kernel) }

  subject { described_class.new.run }

  describe '#run' do
    before do
      ENV['ACCESS_TOKEN'] = 'Sample Access Token'
      ENV['TERRAFORM_DIRECTORY_PATH'] = "#{__dir__}/fixtures"
      ENV['ORGANIZATION_NAME'] = 'organization-test'

      agent = Sawyer::Agent.new(
        'https://api.github.com',
        links_parser: Sawyer::LinkParsers::Simple.new
      )

      file = File.open("#{__dir__}/fixtures/organization.json")
      response = file.read
      hashed_response = JSON.parse(response)

      resource = Sawyer::Resource.new(agent, hashed_response)
      allow(Octokit::Client).to receive(:new).and_return(octokit_client)
      allow(octokit_client).to receive(:org).and_return(resource)
      allow(Kernel).to receive(:new).and_return(kernel)
      allow(kernel).to receive(:exit).and_return(true)
    end

    it 'this action calls exit method with no arguments.' do
      expect_any_instance_of(Kernel).to receive(:exit).with(no_args).once

      subject
    end
  end
end
